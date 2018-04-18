//
//  UIImageView+WYImageView.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/20.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WYImageView)
/**
 快速创建imageView

 @param name 图片名字
 @param frame frame
 @param superView 其父视图
 
 @return UIImageView *
 */
+ (UIImageView *)imageViewWithImageName:(NSString *)name frame:(CGRect)frame superView:(UIView *)superView;
/**
 快速创建imageView

 @param name  图片名字
 @param superView 其父视图
 
 @return UIImageView *
 */
+ (UIImageView *)imageViewWithImageName:(NSString *)name superView:(UIView *)superView;
/**
 快速创建imageView

 @param superView 其父视图
 
 @return UIImageView *
 */
+ (UIImageView *)imageViewWithSuperView:(UIView *)superView;
/**
 快速创建imageView

 @param name 图片名字
 @param frame frame
 
 @return UIImageView *
 */
+ (UIImageView *)imageViewWithImageName:(NSString *)name frame:(CGRect)frame;
/**
 快速创建imageView

 @param frame frame
 @param image 图片名字
 @param cornerRadius 圆角半径
 @param borderWidth 描边宽度
 @param borderColor 描边颜色
 
 @return UIImageView *
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor;
@end
