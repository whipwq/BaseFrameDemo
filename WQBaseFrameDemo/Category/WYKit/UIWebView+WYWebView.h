//
//  UIWebView+WYWebView.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/27.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (WYWebView)
/**
 快速创建webView

 @param frame frame
 @param superView 其父视图
 
 @return UIWebView *
 */
+ (UIWebView *)webViewWithFrame:(CGRect)frame superView:(UIView *)superView;

@end
