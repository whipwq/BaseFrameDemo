//
//  UTLiteCameraSession.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UTLiteCameraSessionDelegate;

@interface UTLiteCameraSession : NSObject

@property (nonatomic, readonly) BOOL videoInitialized;
@property (nonatomic, readonly) BOOL audioInitialized;

@property (nonatomic, weak) id<UTLiteCameraSessionDelegate> delegate;

- (instancetype)initWithTempFilePath:(NSString *)tempFilePath;
// 给 asset writer 视屏设置添加描述和拓展
- (void)addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)videoSettings;
// 给 asset writer 音频设置添加描述和拓展
- (void)addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary *)audioSettings;
// Video样本缓存
- (void)appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
// Audio样本缓存
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;
// 准备录制
- (void)prepareToRecord;
// 完成录制
- (void)finishRecording;

@end

@protocol UTLiteCameraSessionDelegate <NSObject>

- (void)sessionDidFinishPreparing:(UTLiteCameraSession *)session;
- (void)session:(UTLiteCameraSession *)session didFailWithError:(NSError *)error;
- (void)sessionDidFinishRecording:(UTLiteCameraSession *)session;

@end

NS_ASSUME_NONNULL_END