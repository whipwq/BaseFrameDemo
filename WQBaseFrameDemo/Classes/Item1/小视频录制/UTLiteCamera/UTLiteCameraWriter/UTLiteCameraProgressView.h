//
//  UTLiteCameraProgressView.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTLiteCameraProgressView : UIView

- (instancetype)initWithFrame:(CGRect)frame themeColor:(UIColor *)themeColor duration:(NSTimeInterval)duration;
- (void)play;
- (void)stop;
- (void)restore;

@end
