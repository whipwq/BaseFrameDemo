//
//  UIImage+UTLiteCameraPlayer.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAsset;
@interface UIImage (UTLiteCameraPlayer)
//获取视频第一帧图片
+ (UIImage *)ut_previewImageWithVideoURL:(NSURL *)videoURL;
@end
