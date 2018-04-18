//
//  UILabel+WYLabel.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/20.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WYLabel)
/**
 快速创建label

 @param font 字体大小
 @param textColor 字体颜色
 @param superView 其父视图
 
 @return UILabel *
 */
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView;
/**
 快速创建label

 @param font 字体大小
 @param textColor 字体颜色
 @param text 文本内容
 @param superView 其父视图
 
 @return UILabel *
 */
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text superView:(UIView *)superView;

/**
 快速创建label

 @param font 字体大小
 @param textColor 字体颜色
 @param text 文本内容
 @param superView 其父视图
 @param frame frame
 
 @return UILabel *
 */
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text superView:(UIView *)superView frame:(CGRect)frame;
/**
 快速创建label

 @param font 字体大小
 @param textColor 字体颜色
 @param superView 其父视图
 @param Alignment 文本排列格式
 
 @return UILabel *
 */
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment;
/**
 快速创建label

 @param font 字体大小
 @param textColor 字体颜色
 @param superView 其父视图
 @param Alignment 文本排列格式
 @param text 文本内容
 
 @return UILabel *
 */
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment text:(NSString *)text;
/**
 快速创建label

 @param frame frame
 @param text 文本内容
 @param font 字体大小
 @param textColor 字体颜色
 
 @return UILabel *
 */
+ (UILabel *)labelWithframe:(CGRect)frame text:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor;
/**
 快速创建label

 @param font 字体大小
 @param textColor 字体颜色
 @param superView 其父视图
 @param Alignment 文本排列格式
 @param text 文本内容
 @param frame frame
 
 @return UILabel *
 */
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment text:(NSString *)text frame:(CGRect)frame;
/**
 快速创建label

 @param font 字体大小
 @param textColor 字体颜色
 @param superView 其父视图
 @param Alignment 文本排列格式
 @param backgroundColor 背景颜色
 
 @return UILabel *
 */
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment backgroundColor:(UIColor *)backgroundColor;

@end
