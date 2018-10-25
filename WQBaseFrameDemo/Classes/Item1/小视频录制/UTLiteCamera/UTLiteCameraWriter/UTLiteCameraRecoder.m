//
//  UTLiteCameraRecoder.m
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UTLiteCameraRecoder.h"
#import "UTLiteCameraSession.h"

typedef NS_ENUM( NSInteger, UTRecordingStatus ) {
    UTRecordingStatusIdle = 0,          // 闲置
    UTRecordingStatusStartingRecording, // 开始录制
    UTRecordingStatusRecording,         // 录制中
    UTRecordingStatusStoppingRecording, // 录制结束
};
@interface UTLiteCameraRecoder() <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, UTLiteCameraSessionDelegate>
// 视频路径
@property (nonatomic, strong) NSString *outputFilePath;
// 输出视频的size
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, strong) NSString *tempFilePath;

@property (nonatomic, strong) dispatch_queue_t recorderQueue;

@property (nonatomic, strong) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) dispatch_queue_t audioDataOutputQueue;
// 视屏数据输出
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
// 音频数据输出
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
// 视频通道
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
// 音频通道
@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
// 视屏的拓展设置
@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
// 音频的拓展设置
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;

@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;
// recorder状态
@property (nonatomic, assign) UTRecordingStatus recordingStatus;

@property (nonatomic, retain) UTLiteCameraSession *assetSession;
@end

@implementation UTLiteCameraRecoder
#pragma mark - Init

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize {
    self = [super init];
    if (self) {
        _outputFilePath = outputFilePath;
        _tempFilePath = outputFilePath;
        _outputSize = outputSize;
        // 微信小视频官方demo 建议用串行队列
        _recorderQueue = dispatch_queue_create("VideoWriter.sessionQueue", DISPATCH_QUEUE_SERIAL );
        _audioDataOutputQueue = dispatch_queue_create("VideoWriter.audioOutput", DISPATCH_QUEUE_SERIAL );
        _videoDataOutputQueue = dispatch_queue_create("VideoWriter.videoOutput", DISPATCH_QUEUE_SERIAL );
        dispatch_set_target_queue(_videoDataOutputQueue, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ) );
        //初始化CaptureSession
        _captureSession = [self setupCaptureSession];
        //把音频、视屏数据输出配置进captureSession
        [self addDataOutputsToCaptureSession:self.captureSession];
        
    }
    return self;
}

- (void)dealloc {
    [_assetSession finishRecording];
    [self stopRunning];
}



#pragma mark - Running Session

- (void)startRunning {
    dispatch_sync(self.recorderQueue, ^{
        [self.captureSession startRunning];
    } );
}

- (void)stopRunning {
    dispatch_sync(self.recorderQueue, ^{
        [self stopRecording];
        [self.captureSession stopRunning];
    } );
}



#pragma mark - Recording
// 开始录制
- (void)startRecording {
    if (TARGET_IPHONE_SIMULATOR) {
        NSLog(@"录制视频不支持模拟器");
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"录制视频不支持模拟器" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
#pragma clang diagnostic pop
        return;
    }
    //线程锁，限制多线程访问
    @synchronized(self) {
        if (self.recordingStatus != UTRecordingStatusIdle) {
            NSLog(@"已经在录制了");
            return;
        }
        [self transitionToRecordingStatus:UTRecordingStatusStartingRecording error:nil];
    }
   //初始化assetSession
    self.assetSession = [[UTLiteCameraSession alloc] initWithTempFilePath:self.outputFilePath];
    self.assetSession.delegate = self;
    
    //把音频视频的压缩方案 传递给asset writer
    [self.assetSession addVideoTrackWithSourceFormatDescription:self.outputVideoFormatDescription settings:self.videoCompressionSettings];
    [self.assetSession addAudioTrackWithSourceFormatDescription:self.outputAudioFormatDescription settings:self.audioCompressionSettings];
    
    //为录制做准备
    [self.assetSession prepareToRecord];
}
//结束录制
- (void)stopRecording {
    @synchronized(self) {
        if (self.recordingStatus != UTRecordingStatusRecording){
            return;
        }
        [self transitionToRecordingStatus:UTRecordingStatusStoppingRecording error:nil];
    }
    [self.assetSession finishRecording];
}

#pragma mark - Change Focus Point
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}
/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(void(^)(AVCaptureDevice *captureDevice))propertyChange{
    
    AVCaptureDevice *captureDevice= self.cameraDevice;
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

#pragma mark - SwapCamera

- (void)swapFrontAndBackCameras {
    //取出所有输入配置
    NSArray *inputs = self.captureSession.inputs;
    
    for ( AVCaptureDeviceInput *input in inputs ) {
        //取出输入配置的设备
        AVCaptureDevice *device = input.device;
        
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            // 取出前后置摄像头
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            } else {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            // 切换
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            //beginConfiguration 确保改变不会立刻应用
            [self.captureSession beginConfiguration];
            // 重置输出数据流和输入设备
            [self.captureSession removeOutput:self.videoDataOutput];
            [self.captureSession removeOutput:self.audioDataOutput];
            
            [self.captureSession removeInput:input];
            [self.captureSession addInput:newInput];
            
            self.outputVideoFormatDescription = nil;
            self.outputAudioFormatDescription = nil;
            //开始生效
            [self.captureSession commitConfiguration];
            //重新加载
            [self addDataOutputsToCaptureSession:self.captureSession];
            break;
        }
    }
}



#pragma mark - Private methods
//把音频、视屏数据输出配置进captureSession
- (void)addDataOutputsToCaptureSession:(AVCaptureSession *)captureSession {
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    self.videoDataOutput.videoSettings = nil;
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    self.audioDataOutput = [AVCaptureAudioDataOutput new];
    [self.audioDataOutput setSampleBufferDelegate:self queue:self.audioDataOutputQueue];
    
    [self addOutput:self.videoDataOutput toCaptureSession:self.captureSession];
    self.videoConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [self addOutput:self.audioDataOutput toCaptureSession:self.captureSession];
    self.audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    
    //设置压缩方案
    //如果你想要对影音输出有更多的操作，你可以使用 AVCaptureVideoDataOutput 和 AVCaptureAudioDataOutput
    //这些输出将会各自捕获视频和音频的样本缓存，接着发送到它们的代理。代理要么对采样缓冲进行处理 (比如给视频加滤镜)，要么保持原样传送。使用 AVAssetWriter 对象可以将样本缓存写入文件
    //我们将 asset writer 的 outputSettings 设置为 nil。这就意味着附加上来的样本不会再被重新编码。如果你确实想要重新编码这些样本，那么需要提供一个包含具体输出参数的字典。
    [self setCompressionSettings];
}
//音频视频，压缩方案（考虑压缩后视频的分辨率以及保证预览拍摄视频与最终生成视频图像一致。）
- (void)setCompressionSettings {
    NSInteger numPixels = self.outputSize.width * self.outputSize.height;
    //每像素比特
    CGFloat bitsPerPixel = 6.0;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
    
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                             AVVideoExpectedSourceFrameRateKey : @(30),
                                             AVVideoMaxKeyFrameIntervalKey : @(30),
                                             AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel };
    
    self.videoCompressionSettings = [self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];
    
    self.videoCompressionSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                       AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                       AVVideoWidthKey : @(self.outputSize.height),
                                       AVVideoHeightKey : @(self.outputSize.width),
                                       AVVideoCompressionPropertiesKey : compressionProperties };
    
    // 音频设置
    self.audioCompressionSettings = @{ AVEncoderBitRatePerChannelKey : @(28000),
                                       AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                       AVNumberOfChannelsKey : @(1),
                                       AVSampleRateKey : @(22050) };
}



#pragma mark - SampleBufferDelegate methods
//视频样本缓存
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == self.videoConnection){
        if (!self.outputVideoFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputVideoFormatDescription = formatDescription;
            }
        } else {
            @synchronized(self) {
                if (self.recordingStatus == UTRecordingStatusRecording){
                    [self.assetSession appendVideoSampleBuffer:sampleBuffer];
                }
            }
        }
    } else if (connection == self.audioConnection ){
        if (!self.outputAudioFormatDescription) {
            @synchronized(self) {
                CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                self.outputAudioFormatDescription = formatDescription;
            }
        }
        @synchronized(self) {
            if (self.recordingStatus == UTRecordingStatusRecording){
                [self.assetSession appendAudioSampleBuffer:sampleBuffer];
            }
        }
    }
}

#pragma mark - UTAssetWriterDelegate methods
//session准备完成
- (void)sessionDidFinishPreparing:(UTLiteCameraRecoder *)writer {
    @synchronized(self) {
        if (self.recordingStatus != UTRecordingStatusStartingRecording){
            return;
        }
        [self transitionToRecordingStatus:UTRecordingStatusRecording error:nil];
    }
}
//session准备失败
- (void)session:(UTLiteCameraRecoder *)writer didFailWithError:(NSError *)error {
    @synchronized(self) {
        self.assetSession = nil;
        [self transitionToRecordingStatus:UTRecordingStatusIdle error:error];
    }
}

- (void)sessionDidFinishRecording:(UTLiteCameraRecoder *)writer {
    @synchronized(self) {
        if ( self.recordingStatus != UTRecordingStatusStoppingRecording ) {
            return;
        }
    }
    self.assetSession = nil;
    
    @synchronized(self) {
        [self transitionToRecordingStatus:UTRecordingStatusIdle error:nil];
    }
}


#pragma mark - Recording State Machine
// Recorder 状态变化对应事件
- (void)transitionToRecordingStatus:(UTRecordingStatus)newStatus error:(NSError *)error {
    
    UTRecordingStatus oldStatus = self.recordingStatus;
    self.recordingStatus = newStatus;
    
    if (newStatus != oldStatus){
        if (error && (newStatus == UTRecordingStatusIdle)){//录制发生错误
            dispatch_async( dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    if ([self.delegate respondsToSelector:@selector(recorder:didFinishRecordingToOutputFilePath:error:)]) {
                        //把错误信息通知代理
                        [self.delegate recorder:self didFinishRecordingToOutputFilePath:self.outputFilePath error:error];
                    }
                }
            });
        } else {
            error = nil;
            if (oldStatus == UTRecordingStatusStartingRecording && newStatus == UTRecordingStatusRecording){// 已经开始录制
                dispatch_async( dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        if ([self.delegate respondsToSelector:@selector(recorderDidBeginRecording:)]) {
                             [self.delegate recorderDidBeginRecording:self];
                        }
                    }
                });
            } else if (oldStatus == UTRecordingStatusStoppingRecording && newStatus == UTRecordingStatusIdle) {// 录制结束
                dispatch_async( dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        if ([self.delegate respondsToSelector:@selector(recorderDidEndRecording:)]&&[self.delegate respondsToSelector:@selector(recorder:didFinishRecordingToOutputFilePath:error:)]) {
                            
                            [self.delegate recorderDidEndRecording:self];
                            [self.delegate recorder:self didFinishRecordingToOutputFilePath:self.outputFilePath error:nil];
                        }
                        
                    }
                });
            }
        }
    }
}

#pragma mark - Capture Session Setup

// 初始化CaptureSession
- (AVCaptureSession *)setupCaptureSession {
    
    AVCaptureSession *captureSession = [AVCaptureSession new];
    
    if (self.outputSize.width > 360 || self.outputSize.width/self.outputSize.height > 4/3) {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720;//720 x 1280
    } else {
        captureSession.sessionPreset = AVCaptureSessionPresetMedium;//360 x 480 小视频一般不会超过此尺寸
    }
    
    if (![self addDefaultCameraInputToCaptureSession:captureSession]){
        NSLog(@"加载摄像头失败");
    }
    if (![self addDefaultMicInputToCaptureSession:captureSession]){
        NSLog(@"加载麦克风失败");
    }
    
    return captureSession;
}
// 为CaptureSession配置摄像头
- (BOOL)addDefaultCameraInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error;
    AVCaptureDeviceInput *cameraDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:&error];
    
    if (error) {
        NSLog(@"配置摄像头输入错误: %@", [error localizedDescription]);
        return NO;
    } else {
        BOOL success = [self addInput:cameraDeviceInput toCaptureSession:captureSession];
        self.cameraDevice = cameraDeviceInput.device;
        return success;
    }
}
// 为CaptureSession配置麦克风
- (BOOL)addDefaultMicInputToCaptureSession:(AVCaptureSession *)captureSession {
    NSError *error;
    AVCaptureDeviceInput *micDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    if (error){
        NSLog(@"配置麦克风输入错误: %@", [error localizedDescription]);
        return NO;
    } else {
        BOOL success = [self addInput:micDeviceInput toCaptureSession:captureSession];
        return success;
    }
}
// 在此主要是为前后置摄像头切换
- (BOOL)addInput:(AVCaptureDeviceInput *)input toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddInput:input]){
        [captureSession addInput:input];
        return YES;
    } else {
        NSLog(@"不能添加输入: %@", [input description]);
    }
    return NO;
}

// 是否能添加数据输出
- (BOOL)addOutput:(AVCaptureOutput *)output toCaptureSession:(AVCaptureSession *)captureSession {
    if ([captureSession canAddOutput:output]){
        [captureSession addOutput:output];
        return YES;
    } else {
        NSLog(@"不能添加输出 %@", [output description]);
    }
    return NO;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            return device;
        }
    }
    return nil;
}


#pragma mark - Getter

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer && _captureSession){
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    }
    return _previewLayer;
}

- (BOOL)cameraEnable {
    
    NSArray *inputs = self.captureSession.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        
        AVCaptureDevice *device = input.device;
        if(!device) {
            return NO;
        }
    }
    return true;
}
@end
