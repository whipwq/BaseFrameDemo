//
//  UTLiteCameraManager.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UTLiteCameraConfiguration.h"

typedef void(^CompleteBlock)(NSString *filePath,NSString *message);

@class UTLiteCameraConfiguration;

@interface UTLiteCameraManager : NSObject

+ (instancetype)shareInstance;

/**
 快速初始化方法

 @param fromVC 当前VC
 @param complete 录制结束回调
 */
+ (void)ut_CameraFromVC:(UIViewController *)fromVC
               complete:(CompleteBlock)complete;

/**
 自定义的初始化方法

 @param fromVC 当前VC
 @param configuration 自定义参数
 @param complete 录制结束回调
 */
+ (void)ut_CameraFromVC:(UIViewController *)fromVC
          configuration:(UTLiteCameraConfiguration *)configuration
               complete:(CompleteBlock)complete;


// File Operation

/**
 检查对应路径文件是否存在

 @param filePath 文件路径
 @return 存在-YES 不存在-NO
 */
+ (BOOL)ut_checkFileExist:(NSString *)filePath;

/**
 获取视频缓存路径

 @return 视频缓存路径
 */
+ (NSString *)ut_getVideoFilePath;

/**
 快速构建包含视频文件名的路径

 @return 包含视频名称的文件路径
 */
+ (NSString *)ut_quickConstructFilePath;
@end
