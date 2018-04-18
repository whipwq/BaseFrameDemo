//
//  UIWebView+WYWebView.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/27.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UIWebView+WYWebView.h"

@implementation UIWebView (WYWebView)

+ (UIWebView *)webViewWithFrame:(CGRect)frame superView:(UIView *)superView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    [superView addSubview:webView];
    return webView;
}

@end
