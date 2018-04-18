//
//  UIButton+WYButton.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WYButton)
/**
 快速创建Button
 
 @param image 图片
 @return UIButton *
 */
+ (UIButton *)buttonWithImage:(NSString *)image;
/**
 快速创建Button
 
 @param frame frame
 @param superView 其父视图
 
 @return UIButton *
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame superView:(UIView *)superView;
/**
 快速创建Button

 @param image 图片
 @param frame frame
 @param superView 其父视图
 
 @return UIButton *
 */
+ (UIButton *)buttonWithImage:(NSString *)image frame:(CGRect)frame superView:(UIView *)superView;
/**
 快速创建Button

 @param image 图片
 @param frame frame
 @param action button触发事件
 @param source target对象
 
 @return UIButton *
 */
+ (UIButton *)buttonWithImage:(NSString *)image frame:(CGRect) frame action:(SEL)action source:(id)source;
/**
 快速创建Button
 
 @param image 图片
 @param selectImage 选中状态图片
 @param frame frame
 @param action button触发事件
 @param source target对象
 
 @return UIButton *
 */
+ (UIButton *)buttonWithImage:(NSString *)image selectImage:(NSString*) selectImage title:(NSString*)title frame:(CGRect) frame action:(SEL)action source:(id)source;
/**
 快速创建Button

 @param title 标题
 @param textColor 字体颜色
 @param font 字体大小
 @param superView 其父视图
 
 @return UIButton *
 */
+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font superView:(UIView *)superView;
/**
 快速创建Button

 @param title 标题
 @param textColor 字体颜色
 @param font 字体大小
 @param action button触发事件
 @param frame frame
 @param source target对象
 
 @return UIButton *
 */
+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font action:(SEL)action frame:(CGRect) frame source:(id)source;
/**
 快速创建Button

 @param bgColor 背景颜色
 @param title 标题
 @param textColor 字体颜色
 @param font 字体大小
 @param superView 其父视图
 
 @return UIButton *
 */
+ (UIButton *)buttonWithBgColor:(UIColor *)bgColor title:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font superView:(UIView *)superView;
/**
 快速创建Button

 @param bgColor 背景颜色
 @param title 标题
 @param textColor 字体颜色
 @param font 字体大小
 @param superView 其父视图
 @param frame frame
 @param cornerRadius 圆角半径
 
 @return UIButton *
 */
+ (UIButton *)buttonWithBgColor:(UIColor *)bgColor title:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font superView:(UIView *)superView frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;
/**
 快速创建Button

 @param title 标题
 @param textColor 字体颜色
 @param font 字体大小
 @param action button触发事件
 @param frame frame
 @param source target对象
 @param superView 其父视图
 
 @return UIButton *
 */
+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font action:(SEL)action frame:(CGRect) frame source:(id)source superView:(UIView *)superView;

/**
 快速创建Button

 @param title 标题
 @param textColor 字体颜色
 @param font 字体大小
 @param action button触发事件
 @param frame frame
 @param source target对象
 @param superView 其父视图
 @param borderWidth 描边宽度
 @param borderColor 描边颜色
 @param cornerRadius 圆角半径
 
 @return UIButton *
 */
+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font action:(SEL)action frame:(CGRect) frame source:(id)source superView:(UIView *)superView borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;

/**
 图片在上，文字在下

 @param spacing 间距
 */
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;

/**
 倒计时按钮
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;
/**
 停止倒计时
 */
// - (void)stopTimer;

/**
 防止按钮重复点击

 @param interval 间隔时间
 */
- (void)setAcceptClickInterval:(NSInteger)interval;

@end
