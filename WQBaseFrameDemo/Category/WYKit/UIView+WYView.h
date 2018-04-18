//
//  UIView+WYView.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WYView)
/** 坐标原点x */
- (CGFloat)x;
/** 坐标原点y */
- (CGFloat)y;
/** 高 */
- (CGFloat)height;
/** 宽 */
- (CGFloat)width;
/**
 快速创建view

 @param superView 其父视图
 
 @return UIView *
 */
+ (UIView *)viewWithSuperView:(UIView *)superView;
/**
 快速创建view

 @param bgColor 背景颜色
 @param superView 其父视图
 
 @return UIView *
 */
+ (UIView *)viewWithBgColor:(UIColor *)bgColor superView:(UIView *)superView;
/**
 快速创建view

 @param frame frame
 @param bgColor 背景颜色
 @param superView 其父视图
 
 @return UIView *
 */
+ (UIView *)viewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView;
/**
 快速创建view

 @param frame frame
 @param bgColor 背景颜色
 @param superView 其父视图
 @param alpha 透明度
 
 @return UIView *
 */
+ (UIView *)viewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView alpha:(CGFloat)alpha;
/**
 * 删除所有子视图
 */
- (void)removeAllSubViews;
/**
 * 获取当前控制器
 */
- (UIViewController *)getCurrentViewController;

/** 边框颜色*/
@property (nonatomic, strong) UIColor *borderColor;

/**
 裁剪圆角（上左，上右）

 @param rect 父视图大小
 @param corner 圆角大小
 */
-(void)layerMaskRectUpLeftUpRight:(CGRect)rect cornerSize:(CGSize)corner;

/**
 去除emoji表情

 @param view textfield textview
 @param length 最大长度
 @param isShowEmoji 是否显示表情
 */
+ (void)textField:(id)view maxLength:(NSInteger)length showEmoji:(BOOL) isShowEmoji;

@end
