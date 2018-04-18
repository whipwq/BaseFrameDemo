//
//  UILabel+WYLabel.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/20.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UILabel+WYLabel.h"

@implementation UILabel (WYLabel)

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    [superView addSubview:label];
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text superView:(UIView *)superView {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.text = text;
    [superView addSubview:label];
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text superView:(UIView *)superView frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.text = text;
    [superView addSubview:label];
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView];
    label.textAlignment = alignment;
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment text:(NSString *)text {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView alignment:Alignment];
    label.text = text;
    return label;
}

+ (UILabel *)labelWithframe:(CGRect)frame text:(NSString *)text font:(CGFloat)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.textAlignment = 1;
    label.textColor = textColor;
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment text:(NSString *)text frame:(CGRect)frame {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView alignment:Alignment text:text];
    label.frame = frame;
    return label;
}

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor superView:(UIView *)superView alignment:(NSTextAlignment)Alignment backgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor superView:superView alignment:Alignment];
    label.backgroundColor = backgroundColor;
    return label;
}

@end
