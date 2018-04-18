//
//  UIView+WYView.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UIView+WYView.h"

@implementation UIView (WYView)

@dynamic borderColor;

- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (CGFloat)width {
    return self.frame.size.width;
}

+ (UIView *)viewWithSuperView:(UIView *)superView {
    UIView *view = [[UIView alloc] init];
    [superView addSubview:view];
    return view;
}

+ (UIView *)viewWithBgColor:(UIColor *)bgColor superView:(UIView *)superView {
    UIView *view = [UIView viewWithSuperView:superView];
    view.backgroundColor = bgColor;
    return view;
}

+ (UIView *)viewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = bgColor;
    [superView addSubview:view];
    return view;
}

+ (UIView *)viewWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor superView:(UIView *)superView alpha:(CGFloat)alpha {
    UIView *view = [UIView viewWithFrame:frame bgColor:bgColor superView:superView];
    view.alpha = alpha;
    return view;
}

- (void)removeAllSubViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}
- (UIViewController *)getCurrentViewController {
    
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

-(void)setBorderColor:(UIColor *)borderColor {
    
    self.layer.borderColor = borderColor.CGColor;
}


-(void)layerMaskRectUpLeftUpRight:(CGRect)rect cornerSize:(CGSize)corner{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:corner];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.frame = rect;
    shapeLayer.path = bezierPath.CGPath;
    self.layer.mask = shapeLayer;
    
}


+ (void)textField:(id)view maxLength:(NSInteger)length showEmoji:(BOOL) isShowEmoji{
//
//    UITextField *textField = (UITextField *)view;
//    NSString *toBeString = textField.text;
//    
//    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (!isShowEmoji) {
//                toBeString = [NSString disableEmoji:textField.text];
//                textField.text = toBeString;
//            }
//            if (toBeString.length > length)
//            {
//                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
//                if (rangeIndex.length == 1)
//                {
//                    textField.text = [toBeString substringToIndex:length];
//                }
//                else
//                {
//                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
//                    textField.text = [toBeString substringWithRange:rangeRange];
//                }
//            }
//        }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        if (!isShowEmoji) {
//            toBeString = [NSString disableEmoji:textField.text];
//            textField.text = toBeString;
//        }
//        if (toBeString.length > length)
//        {
//            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
//            if (rangeIndex.length == 1)
//            {
//                textField.text = [toBeString substringToIndex:length];
//            }
//            else
//            {
//                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
//                textField.text = [toBeString substringWithRange:rangeRange];
//            }
//        }
//    }
}
//
@end
