//
//  UTLiteCameraConfiguration.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UTLiteCameraConfiguration : NSObject
/**
 *  自定义button数组,必须依次为 play record refresh
 */
@property (nonatomic,strong) NSArray<UIButton *> *ut_buttons;
/**
 *  聚焦图标
 */
@property (nonatomic,strong) UIImage *img_focusCursor;
/**
 *  切换镜头按钮图标
 */
@property (nonatomic,strong) UIImage *img_swapCamera;
/**
 *  录制过程中是否显示进度条
 */
@property (nonatomic,assign) BOOL isHiddenProgressView;
/**
 *  录制的最大时间 （默认为10秒）
 */
@property (nonatomic, assign) NSTimeInterval videoMaximumDuration;
/**
 *  录制的最小时间 （默认为1秒）
 */
@property (nonatomic, assign) NSTimeInterval videoMinimumDuration;
/**
 *  录制视频的区域（默认为全屏）
 */
@property (nonatomic) CGRect videoFrame;
/**
 *  录制界面控件主体颜色（默认为UTOUU主色调）
 */
@property (nonatomic, strong) UIColor *themeColor;
/**
 *  视频缓存路径
 */
@property (nonatomic,copy) NSString *filePath;
/**
 *  是否同时保存至相簿
 */
@property (nonatomic, assign) BOOL isSaveToPhotoLibary;
@end
