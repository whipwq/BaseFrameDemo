//
//  UTUpdateAlertViewController.h
//  UTAlertTool
//
//  Created by yons on 17/2/8.
//  Copyright © 2017年 温强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UpdateSureBlock)();
typedef void(^UpdateCancleBlocl)();
@interface UTUpdateAlertViewController : UIViewController

- (instancetype)initWithAlertMessage:(NSString *)message
                           imageLogo:(UIImage *)logoImage
                          SureAciton:(UpdateSureBlock)sureBlock
                        cancleAction:(UpdateCancleBlocl)cancleBlock;

@end
