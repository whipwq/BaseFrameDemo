//
//  UTLiteCameraViewController.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UTLiteCameraPlayerViewController.h"
#import "UTLiteCameraManager.h"

#import "UIImage+UTLiteCameraPlayer.h"

@interface UTLiteCameraViewController : UIViewController

/**
 初始化视频录制器
 
 @param configuration 视频录制器配置信息
 @param complete 录制完成回调
 @return 视频录制VC
 */
- (instancetype)initWithConfiguration:(UTLiteCameraConfiguration *)configuration
                             complete:(CompleteBlock)complete ;
@end
