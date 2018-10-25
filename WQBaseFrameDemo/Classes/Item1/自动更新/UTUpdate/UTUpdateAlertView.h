//
//  UTUpdateAlertView.h
//  UTUpdater
//
//  Created by yons on 17/2/9.
//  Copyright © 2017年 liutao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateSureBlock)();
typedef void(^UpdateCancleBlock)();

@interface UTUpdateAlertView : UIView

- (instancetype)initWithAlertMessage:(NSString *)message
                           imageLogo:(UIImage *)logoImage
                          SureAciton:(UpdateSureBlock)sureBlock
                        cancleAction:(UpdateCancleBlock)cancleBlock;

@end
