//
//  UTUpdateAlertView.m
//  UTUpdater
//
//  Created by yons on 17/2/9.
//  Copyright © 2017年 liutao. All rights reserved.
//

#import "UTUpdateAlertView.h"

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//iPhone6s 逻辑尺寸

#define kSUBSCREEN_W(width) (((width)/375.0) * SCREEN_WIDTH)
#define kSUBSCREEN_H(height) (((height)/667.0) * SCREEN_HEIGHT)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0\
                                      green:g / 255.0\
                                       blue:b / 255.0\
                                      alpha:a]

static NSString * const alertTitle = @"版本更新提示";
@interface UTUpdateAlertView ()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, copy) UpdateSureBlock sureBlock;
@property (nonatomic, copy) UpdateCancleBlock cancleBlock;
@property (nonatomic, copy) NSString *AlertMessage;
@property (nonatomic, copy) UIImage *logoImage;
@end

@implementation UTUpdateAlertView

- (instancetype)initWithAlertMessage:(NSString *)message
                           imageLogo:(UIImage *)logoImage
                          SureAciton:(UpdateSureBlock)sureBlock
                        cancleAction:(UpdateCancleBlock)cancleBlock {
    
    if (self = [super init]) {
        
        self.sureBlock = sureBlock;
        self.cancleBlock = cancleBlock;
        self.AlertMessage = message;
        self.logoImage = logoImage;
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self showAlertView];
    }
    return self;
}

#pragma mark -AlertView UI
/**
 * AlertView 的UI可在这定制
 */
- (void)showAlertView {
    
    [self setUpAlertView];
    /**
     * UI为临时所以没写宏 用的魔法数字
     */
    
    UILabel *titleLab = [self createLabelWithFrame:CGRectMake(self.alertView.frame.size.width/2. - kSUBSCREEN_W(60), kSUBSCREEN_H(6), kSUBSCREEN_W(120), kSUBSCREEN_H(30)) text:alertTitle textFont:15.0 textColor:RGBA(0, 0, 0, 1)];
    
    
    UILabel *subLab = [self createLabelWithFrame:CGRectMake(10, 45, self.alertView.frame.size.width - kSUBSCREEN_W(20), kSUBSCREEN_H(30)) text:self.AlertMessage textFont:14.0 textColor:RGBA(13, 158, 110, 1)];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2. - kSUBSCREEN_W(20), kSUBSCREEN_H(85), kSUBSCREEN_W(40), kSUBSCREEN_H(40))];
    logoImage.image = self.logoImage;
    
    UIButton *sureBtn = [self createButtonWithFrame:CGRectMake(kSUBSCREEN_W(5), CGRectGetHeight(self.alertView.frame) - kSUBSCREEN_H(45), self.alertView.frame.size.width/2. - kSUBSCREEN_W(10), kSUBSCREEN_H(40)) title:@"确定" andAction:@selector(sureAction:)];
    
    UIButton *cancleBtn = [self createButtonWithFrame:CGRectMake(self.alertView.frame.size.width/2 + kSUBSCREEN_W(5), CGRectGetHeight(self.alertView.frame) - kSUBSCREEN_H(45), self.alertView.frame.size.width/2. - kSUBSCREEN_W(10), kSUBSCREEN_H(40)) title:@"取消" andAction:@selector(cancleAction:)];
    
    [self.alertView addSubview:titleLab];
    [self.alertView addSubview:subLab];
    [self.alertView addSubview:logoImage];
    [self.alertView addSubview:sureBtn];
    [self.alertView addSubview:cancleBtn];
}

- (void)setUpAlertView {
    self.alertView = [[UIView alloc] init];
    self.alertView.center = CGPointMake(SCREEN_WIDTH/2., SCREEN_HEIGHT/2.);
    self.alertView.bounds = CGRectMake(0, 0, SCREEN_WIDTH - kSUBSCREEN_W(32), kSUBSCREEN_H(208));
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 6;
    self.alertView.clipsToBounds = YES;
    [self addSubview:self.alertView];
    [self shakeToShow:self.alertView];
    // Cancel any scheduled hideDelayed: calls
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setNeedsDisplay];
}
#pragma mark BtnAction

- (void)sureAction:(UIButton *)sender {
    if (self.sureBlock) {
        self.sureBlock();
        self.sureBlock = NULL;
    }
    
    [self hideAlertView];
}

- (void)cancleAction:(UIButton *)sender {
    
    if (self.cancleBlock) {
        self.cancleBlock();
        self.cancleBlock = NULL;
    }
    [self hideAlertView];
}

#pragma mark - 移除视图
- (void)hideAlertView {
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alertView.alpha = 0.0f;
        self.alertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        self.alpha = 0.0f;
        [self hide];
    }];
}

- (void)hide{
       NSAssert([NSThread isMainThread], @"alertview needs to be accessed on the main thread.");
      [NSObject cancelPreviousPerformRequestsWithTarget:self];
       [self removeFromSuperview];
}
#pragma mark - 弹性震颤动画
- (void)shakeToShow:(UIView *)aView {
    CAKeyframeAnimation * popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.35;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @0.8f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [aView.layer addAnimation:popAnimation forKey:nil];
}

#pragma mark - 创建控件
- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title andAction:(SEL)action {

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    btn.layer.borderColor = RGBA(13, 158, 110, 1).CGColor;
    btn.layer.borderWidth = 1.0;
    btn.layer.cornerRadius = 5.0;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textFont:(CGFloat)font textColor:(UIColor *)textColor {
    
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.text = text;
    lab.font = [UIFont systemFontOfSize:font];
    lab.textColor = textColor;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

@end
