//
//  UIScrollView+WYScrollView.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/20.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (WYScrollView)
/**
 快速创建scrollView

 @param frame frame
 @param bgColor 背景颜色
 @param superView 其父视图
 
 @return UIScrollView *
 */
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView;
/**
 快速创建scrollView

 @param frame frame
 @param bgColor 背景颜色
 @param superView 其父视图
 @param size contentSize
 
 @return UIScrollView *
 */
+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView size:(CGSize)size;
/**
 快速创建整页滑动的scrollView

 @param frame frame
 @param bgColor 背景颜色
 @param superView 其父视图
 @param size contentSize
 @param delegate 代理
 
 @return UIScrollView *
 */
+ (UIScrollView *)pageScrollViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView size:(CGSize)size delegate:(id)delegate;

@end
