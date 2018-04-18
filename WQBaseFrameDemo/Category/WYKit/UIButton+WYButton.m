//
//  UIButton+WYButton.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UIButton+WYButton.h"

@implementation UIButton (WYButton)

+ (UIButton *)buttonWithFrame:(CGRect)frame superView:(UIView *)superView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [superView addSubview:button];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font superView:(UIView *)superView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitleColor:textColor forState:0];
    [superView addSubview:button];
    return button;
}

+ (UIButton *)buttonWithImage:(NSString *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:0];
    return button;
}

+ (UIButton *)buttonWithBgColor:(UIColor *)bgColor title:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font superView:(UIView *)superView {
    UIButton *button = [UIButton buttonWithTitle:title textColor:textColor font:font superView:superView];
    button.backgroundColor = bgColor;
    return button;
}

+ (UIButton *)buttonWithBgColor:(UIColor *)bgColor title:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font superView:(UIView *)superView frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius {
    UIButton *button = [UIButton buttonWithBgColor:bgColor title:title textColor:textColor font:font superView:superView];
    button.frame = frame;
    button.layer.cornerRadius = cornerRadius;
    return button;
}

+ (UIButton *)buttonWithImage:(NSString *)image frame:(CGRect)frame superView:(UIView *)superView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:0];
    button.frame = frame;
    [superView addSubview:button];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font action:(SEL)action frame:(CGRect)frame source:(id)source {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:0];
    [button setTitleColor:textColor forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.frame = frame;
    [button addTarget:source action:action forControlEvents:UIControlEventTouchUpInside];
     return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font action:(SEL)action frame:(CGRect)frame source:(id)source superView:(UIView *)superView {
    UIButton *button = [UIButton buttonWithTitle:title textColor:textColor font:font action:action frame:frame source:source];
    [superView addSubview:button];
    return button;
}

+ (UIButton *)buttonWithImage:(NSString *)image frame:(CGRect) frame action:(SEL)action source:(id)source {
    UIButton *button = [UIButton buttonWithImage:image frame:frame superView:nil];
    [button addTarget:source action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton *)buttonWithImage:(NSString *)image selectImage:(NSString *)selectImage title:(NSString*)title frame:(CGRect)frame action:(SEL)action source:(id)source{
    UIButton * button = [self buttonWithTitle:title textColor:[UIColor blackColor] font:14.f superView:nil];
    [button addTarget:source action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];

    return button;
}
+ (UIButton *)buttonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(CGFloat)font action:(SEL)action frame:(CGRect) frame source:(id)source superView:(UIView *)superView borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius {
    UIButton *button = [UIButton buttonWithTitle:title textColor:textColor font:font action:action frame:frame source:source superView:superView];
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor.CGColor;
    button.layer.cornerRadius = cornerRadius;
    return button;
}

- (void)verticalCenterImageAndTitle:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing/2), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing/2), 0.0, 0.0, - titleSize.width);
}


- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = mColor;
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.backgroundColor = color;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

/**
 防止按钮重复点击
 
 @param interval 间隔时间
 */
- (void)setAcceptClickInterval:(NSInteger)interval {
    
    
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval+3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
}





@end
