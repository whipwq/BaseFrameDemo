//
//  UTLiteCameraSession.m
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UTLiteCameraSession.h"

typedef NS_ENUM(NSInteger, UTSessionStatus){
    UTSessionStatusIdle = 0,                // 空闲
    UTSessionStatusPreparingToRecord,       // 准备录制
    UTSessionStatusRecording,               // 录制中
    UTSessionStatusFinishingRecordingPart1, // asset writer 等待写入完成
    UTSessionStatusFinishingRecordingPart2, // asset writer 写入完成
    UTSessionStatusFinished,                // 录制结束
    UTSessionStatusFailed                   // 录制失败
};

@interface UTLiteCameraSession ()

@property (nonatomic, assign) UTSessionStatus status;

@property (nonatomic) dispatch_queue_t writingQueue;
@property (nonatomic) dispatch_queue_t delegateCallbackQueue;

@property (nonatomic) NSString *tempFilePath;

@property (nonatomic) AVAssetWriter *assetWriter;
@property (nonatomic) BOOL haveStartedSession;

@property (nonatomic) CMFormatDescriptionRef audioTrackSourceFormatDescription;
@property (nonatomic) CMFormatDescriptionRef videoTrackSourceFormatDescription;

@property (nonatomic) NSDictionary *audioTrackSettings;
@property (nonatomic) NSDictionary *videoTrackSettings;

@property (nonatomic) AVAssetWriterInput *audioInput;
@property (nonatomic) AVAssetWriterInput *videoInput;

@property (nonatomic) CGAffineTransform videoTrackTransform;


@end

@implementation UTLiteCameraSession
- (instancetype)initWithTempFilePath:(NSString *)tempFilePath {
    if (!tempFilePath) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        // 微信小视频官方demo 建议用串行队列
        _delegateCallbackQueue = dispatch_queue_create("com.UTShortVideoWriter.writerDelegateCallback", DISPATCH_QUEUE_SERIAL );
        _writingQueue = dispatch_queue_create("com.UTShortVideoWriter.assetwriter", DISPATCH_QUEUE_SERIAL );
        
        _videoTrackTransform = CGAffineTransformMakeRotation(M_PI_2);//人像方向
        _tempFilePath = tempFilePath;
    }
    return self;
}

- (void)dealloc {
    [_assetWriter cancelWriting];
}


#pragma mark - Public

//这些输出将会各自捕获视频和音频的样本缓存，接着发送到它们的代理。代理要么对采样缓冲进行处理 (比如给视频加滤镜)，要么保持原样传送。使用 AVAssetWriter 对象可以将样本缓存写入文件
//我们将 asset writer 的 outputSettings 设置为 nil。这就意味着附加上来的样本不会再被重新编码。如果你确实想要重新编码这些样本，那么需要提供一个包含具体输出参数的字典。


//将传进来的视频压缩方案缓存
- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)videoSettings {
    @synchronized(self) {
        self.videoTrackSourceFormatDescription = (CMFormatDescriptionRef)CFRetain(formatDescription);
        self.videoTrackSettings = [videoSettings copy];
    }
}
//将传进来的音频压缩方案缓存
- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings {
    @synchronized(self) {
        self.audioTrackSourceFormatDescription = (CMFormatDescriptionRef)CFRetain(formatDescription);
        self.audioTrackSettings = [audioSettings copy];
    }
}
//添加样本缓存
- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
}
//添加样本缓存
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
}
//为录制做准备
- (void)prepareToRecord {
    @synchronized(self) {
        if (self.status != UTSessionStatusIdle){
            NSLog(@"已经开始准备不需要再准备");
            return;
        }
        //状态切换为准备录制
        [self transitionToStatus:UTSessionStatusPreparingToRecord error:nil];
    }
    
    NSError *error = nil;
    //确保当前url文件不存在
    [[NSFileManager defaultManager] removeItemAtPath:self.tempFilePath error:&error];
    //初始化assetWriter
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.tempFilePath] fileType:AVFileTypeMPEG4 error:&error];
    
    //创建添加输入
    if (!error && _videoTrackSourceFormatDescription) {
        [self setupAssetWriterVideoInputWithSourceFormatDescription:self.videoTrackSourceFormatDescription transform:self.videoTrackTransform settings:self.videoTrackSettings error:&error];
    }
    if (!error && _audioTrackSourceFormatDescription) {
        [self setupAssetWriterAudioInputWithSourceFormatDescription:self.audioTrackSourceFormatDescription settings:self.audioTrackSettings error:&error];
    }
    //开始记录
    if (!error) {
        BOOL success = [self.assetWriter startWriting];
        if (!success) {
            error = self.assetWriter.error;
        }
    }
    
    @synchronized(self) {
        if (error) {
            
            [self transitionToStatus:UTSessionStatusFailed error:error];
        } else {
            // 切换状态为正在录制
            [self transitionToStatus:UTSessionStatusRecording error:nil];
        }
    }
}

//录制结束
- (void)finishRecording {
    @synchronized(self) {
        BOOL shouldFinishRecording = NO;
        //检测状态
        switch (self.status) {
            case UTSessionStatusIdle:
            case UTSessionStatusPreparingToRecord:
            case UTSessionStatusFinishingRecordingPart1:
            case UTSessionStatusFinishingRecordingPart2:
            case UTSessionStatusFinished:
                NSLog(@"还没有开始记录");
                return;
                break;
            case UTSessionStatusFailed:
                NSLog( @"记录失败" );
                break;
            case UTSessionStatusRecording://录制中
                //可结束录制
                shouldFinishRecording = YES;
                break;
        }
        
        if (shouldFinishRecording){
            // 切换状态
            [self transitionToStatus:UTSessionStatusFinishingRecordingPart1 error:nil];
        } else {
            return;
        }
    }
    
    dispatch_async(_writingQueue, ^{
        @autoreleasepool {
            @synchronized(self) {
                if (self.status != UTSessionStatusFinishingRecordingPart1) {
                    return;
                }
                
                [self transitionToStatus:UTSessionStatusFinishingRecordingPart2 error:nil];
            }
            // assetWriter 记录完成回调
            [self.assetWriter finishWritingWithCompletionHandler:^{
                @synchronized(self) {
                    NSError *error = self.assetWriter.error;
                    if (error) {
                        
                        [self transitionToStatus:UTSessionStatusFailed error:error];
                    } else {
                        // 切换状态录制成功
                        [self transitionToStatus:UTSessionStatusFinished error:nil];
                    }
                }
            }];
        }
    } );
}


#pragma mark - Private methods
//将传进来的视频压缩方案设置给asset writer
- (BOOL)setupAssetWriterAudioInputWithSourceFormatDescription:(CMFormatDescriptionRef)audioFormatDescription settings:(NSDictionary *)audioSettings error:(NSError **)errorOut {
    if ([self.assetWriter canApplyOutputSettings:audioSettings forMediaType:AVMediaTypeAudio]){
        self.audioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:audioSettings sourceFormatHint:audioFormatDescription];
        self.audioInput.expectsMediaDataInRealTime = YES;
        
        if ([self.assetWriter canAddInput:self.audioInput]){
            [self.assetWriter addInput:self.audioInput];
        } else {
            if (errorOut) {
                *errorOut = [self cannotSetupInputError];
            }
            return NO;
        }
    }
    else {
        if (errorOut) {
            *errorOut = [self cannotSetupInputError];
        }
        return NO;
    }
    
    return YES;
}
//将传进来的音频压缩方案设置给asset writer
- (BOOL)setupAssetWriterVideoInputWithSourceFormatDescription:(CMFormatDescriptionRef)videoFormatDescription transform:(CGAffineTransform)transform settings:(NSDictionary *)videoSettings error:(NSError **)errorOut {
    if ([self.assetWriter canApplyOutputSettings:videoSettings forMediaType:AVMediaTypeVideo]){
        self.videoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:videoSettings sourceFormatHint:videoFormatDescription];
        self.videoInput.expectsMediaDataInRealTime = YES;
        self.videoInput.transform = transform;
        
        if ([self.assetWriter canAddInput:self.videoInput]){
            [self.assetWriter addInput:self.videoInput];
        } else {
            if (errorOut) {
                *errorOut = [self cannotSetupInputError];
            }
            return NO;
        }
    } else {
        if (errorOut) {
            *errorOut = [self cannotSetupInputError];
        }
        return NO;
    }
    return YES;
}
//添加样本缓存
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType {
    if (sampleBuffer == NULL){
        NSLog(@"不存在sampleBuffer");
        return;
    }
    
    @synchronized(self){
        if (self.status < UTSessionStatusRecording){
            NSLog(@"还没准备好记录");
            return;
        }
    }
    
    CFRetain(sampleBuffer);
    dispatch_async(self.writingQueue, ^{
        @autoreleasepool {
            @synchronized(self) {
                if (self.status > UTSessionStatusFinishingRecordingPart1){
                    
                    CFRelease(sampleBuffer);
                    return;
                }
            }
            
            if (!self.haveStartedSession && mediaType == AVMediaTypeVideo) {
                [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                self.haveStartedSession = YES;
            }
            
            AVAssetWriterInput *input = (mediaType == AVMediaTypeVideo) ? self.videoInput : self.audioInput;
            
            if (input.readyForMoreMediaData){
                BOOL success = [input appendSampleBuffer:sampleBuffer];
                if (!success){
                    NSError *error = self.assetWriter.error;
                    @synchronized(self){
                        [self transitionToStatus:UTSessionStatusFailed error:error];
                    }
                }
            } else {
                NSLog( @"%@ 输入不能添加更多数据了，抛弃 buffer", mediaType );
            }
            CFRelease(sampleBuffer);
        }
    } );
}

- (void)transitionToStatus:(UTSessionStatus)newStatus error:(NSError *)error {
    //是否可以通知代理 （在录制成功、失败、录制中的情况下通知代理）
    BOOL shouldNotifyDelegate = NO;
    
    if (newStatus != self.status){//防止重复设置
        // Status 为完成或失败
        if ((newStatus == UTSessionStatusFinished) || (newStatus == UTSessionStatusFailed)){
            
            shouldNotifyDelegate = YES;
            
            dispatch_async(self.writingQueue, ^{
                // 配置置空
                self.assetWriter = nil;
                self.videoInput = nil;
                self.audioInput = nil;
                // Status 为失败 删除路径下的文件
                if (newStatus == UTSessionStatusFailed) {
                    
                    [[NSFileManager defaultManager] removeItemAtPath:self.tempFilePath error:NULL];
                }
            } );
        } else if (newStatus == UTSessionStatusRecording){//正在录制
            
            shouldNotifyDelegate = YES;
        }
        // 更新状态
        self.status = newStatus;
    }
    //通知代理
    if (shouldNotifyDelegate && self.delegate){
        dispatch_async(self.delegateCallbackQueue, ^{
            @autoreleasepool {
                switch(newStatus){
                    case UTSessionStatusRecording:// 录制中
                        
                        if ([self.delegate respondsToSelector:@selector(sessionDidFinishPreparing:)]) {
                            [self.delegate sessionDidFinishPreparing:self];
                        }
                        break;
                    case UTSessionStatusFinished: // 录制结束
                        if ([self.delegate respondsToSelector:@selector(sessionDidFinishRecording:)]) {
                            [self.delegate sessionDidFinishRecording:self];
                        }
                        break;
                    case UTSessionStatusFailed: // 录制失败
                        if ([self.delegate respondsToSelector:@selector(sessionDidFinishRecording:)]) {
                            [self.delegate session:self didFailWithError:error];
                        }
                        break;
                    default:
                        break;
                }
            }
        });
    }
}

- (NSError *)cannotSetupInputError {
    NSDictionary *errorDict = @{ NSLocalizedDescriptionKey : @"记录不能开始",
                                 NSLocalizedFailureReasonErrorKey : @"不能初始化writer" };
    return [NSError errorWithDomain:@"com.UTShortVideoWriter" code:0 userInfo:errorDict];
}


#pragma mark - Getter

- (BOOL)videoInitialized {
    return _videoInput != nil;
}

- (BOOL)audioInitialized {
    return _audioInput != nil;
}

@end
