//
//  UIScrollView+WYScrollView.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/20.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UIScrollView+WYScrollView.h"

@implementation UIScrollView (WYScrollView)

+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = bgColor;
    [superView addSubview:scrollView];
    return scrollView;
}

+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView size:(CGSize)size {
    UIScrollView *scrollView = [UIScrollView scrollViewWithFrame:frame bgColor:bgColor superView:superView];
    scrollView.contentSize = size;
    return scrollView;
}

+ (UIScrollView *)pageScrollViewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView size:(CGSize)size delegate:(id)delegate {
    UIScrollView *scrollView = [UIScrollView scrollViewWithFrame:frame bgColor:bgColor superView:superView size:size];
    scrollView.pagingEnabled = YES;
//    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;  // 设成白色了
    scrollView.delegate = delegate;
    return scrollView;
}



@end
