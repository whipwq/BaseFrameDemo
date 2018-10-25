//
//  UTLiteCameraRecoder.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UTLiteCameraRecoder;

@protocol UTLiteCameraRecoderDelegate<NSObject>

@required
- (void)recorderDidBeginRecording:(UTLiteCameraRecoder *)recorder;
- (void)recorderDidEndRecording:(UTLiteCameraRecoder *)recorder;
- (void)recorder:(UTLiteCameraRecoder *)recorder didFinishRecordingToOutputFilePath:(nullable NSString *)outputFilePath error:(nullable NSError *)error;

@end

@class AVCaptureVideoPreviewLayer;

@interface UTLiteCameraRecoder : NSObject

@property (nonatomic, weak) id<UTLiteCameraRecoderDelegate> delegate;

- (instancetype)initWithOutputFilePath:(NSString *)outputFilePath outputSize:(CGSize)outputSize;

- (void)startRunning;
- (void)stopRunning;

- (void)startRecording;
- (void)stopRecording;
// 是否可用
- (BOOL)cameraEnable;
// 切换前后置摄像头
- (void)swapFrontAndBackCameras;
// 拍摄预览layer
- (AVCaptureVideoPreviewLayer *)previewLayer;
// 手动聚焦
- (void)focusWithMode:(AVCaptureFocusMode)focusMode
        exposureMode:(AVCaptureExposureMode)exposureMode
             atPoint:(CGPoint)point;

@end
NS_ASSUME_NONNULL_END
