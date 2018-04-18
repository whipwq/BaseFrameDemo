//
//  WQBadgeValue.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/23.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "WQBadgeValue.h"
#import "UIView+CMKit.h"
#define BadgeViewFont [UIFont systemFontOfSize:11]
@implementation WQBadgeValue
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        
        // 设置字体大小
        self.titleLabel.font = BadgeViewFont;
        [self addTarget:self action:@selector(shake) forControlEvents:UIControlEventTouchUpInside];
        [self sizeToFit];
        
    }
    return self;
}

- (void)shake {
    [self shakeView];
}
- (void)setBadgeValue:(NSString *)badgeValue
{   
    _badgeValue = badgeValue;
    
    // 判断badgeValue是否有内容
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) { // 没有内容或者空字符串,等于0
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    NSDictionary *attr = @{NSFontAttributeName:BadgeViewFont};
    CGSize size = [badgeValue sizeWithAttributes:attr];
    // 文字的尺寸大于控件的宽度
    if (size.width > self.width) {
        
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
    
}



@end
