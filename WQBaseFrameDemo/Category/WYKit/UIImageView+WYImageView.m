//
//  UIImageView+WYImageView.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/20.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UIImageView+WYImageView.h"

@implementation UIImageView (WYImageView)

+ (UIImageView *)imageViewWithImageName:(NSString *)name superView:(UIView *)superView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [superView addSubview:imageView];
    return imageView;
}

+ (UIImageView *)imageViewWithSuperView:(UIView *)superView {
    UIImageView *imageView = [[UIImageView alloc] init];
    [superView addSubview:imageView];
    return imageView;
}

+ (UIImageView *)imageViewWithImageName:(NSString *)name frame:(CGRect)frame {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    image.frame = frame;
    return image;
}

+ (UIImageView *)imageViewWithImageName:(NSString *)name frame:(CGRect)frame superView:(UIView *)superView {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    image.frame = frame;
    [superView addSubview:image];
    return image;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    
    imageView.layer.cornerRadius = cornerRadius;
    imageView.layer.borderWidth = borderWidth;
    imageView.layer.borderColor = borderColor;
    
    return imageView;
}

@end
