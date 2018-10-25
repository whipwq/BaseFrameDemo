//
//  UTButton.m
//  UTAccount
//
//  Created by yons on 17/2/16.
//  Copyright © 2017年 陈凤林. All rights reserved.
//

#import "UTButton.h"

@implementation UTButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatButton];
    }
    
    return self;
}

- (void)creatButton {
    [self setBackgroundImage:[UIImage imageNamed:@"button默认"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"button点击"] forState:UIControlStateHighlighted];
    
//    [self setTitle:@"确定" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
}

@end
