//
//  UTUpdateAlertTool.m
//  UTAlertTool
//
//  Created by yons on 17/2/8.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "UTUpdateAlertTool.h"
#import "UTUpdateAlertViewController.h"
#import "UTUpdateAlertView.h"
#import "UTVersionUpdate.h"
@interface UTUpdateAlertTool()
@property(nonatomic, copy) SureBlock sureBlock;
@property(nonatomic, copy) CancleBlock cancleBlock;

@end

@implementation UTUpdateAlertTool
#pragma mark -sington
+ (UTUpdateAlertTool *)sharedInstance{
    
    static UTUpdateAlertTool* updateAlertTool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        updateAlertTool = [[UTUpdateAlertTool alloc] init];
    });
    return updateAlertTool;
    
}
#pragma mark -alertView

- (void)ut_showUpdateAlert:(UIViewController *)viewController
                   appLogo:(UIImage *)logoImage
                   message:(NSString *)message
                 sureBlock:(SureBlock)sure
               cancleBlock:(CancleBlock)cancle{
    
    self.sureBlock = sure;
    self.cancleBlock = cancle;
    
    UTUpdateAlertViewController *AlertViewController = [[UTUpdateAlertViewController alloc] initWithAlertMessage:message imageLogo:(UIImage *)logoImage SureAciton:^{
        if (self.sureBlock) {
            self.sureBlock();
        }
    } cancleAction:^{
        if (self.cancleBlock) {
            self.cancleBlock();
        }
    }];
    
    [viewController presentViewController:AlertViewController animated:YES completion:nil];

}

- (void)ut_ShowUpdateAlertMessage:(NSString *)message
                          toView:(UIView *)view
                         appLogo:(UIImage *)logoImage
                       sureBlock:(SureBlock)sure
                     cancleBlock:(CancleBlock)cancle {
    
    self.sureBlock = sure;
    self.cancleBlock = cancle;

    UTUpdateAlertView *AlertView = [[UTUpdateAlertView alloc] initWithAlertMessage:message imageLogo:(UIImage *)logoImage SureAciton:^{
        
        if (self.sureBlock) {
            self.sureBlock();
        }
    } cancleAction:^{
        
        if (self.cancleBlock) {
            self.cancleBlock();
        }
    }];
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    AlertView.frame = view.frame;
    [view addSubview:AlertView];
    NSAssert([NSThread mainThread], @"alertView needs to be accessed on the main thread.");
}

+ (void)ut_showUpdateAlertWithAppId:(NSString *)appid appLogoName:(NSString *)logoImageName{

    [UTVersionUpdate ut_checkAppVersionFromAppStoreWithAppID:appid completion:^(BOOL update, NSString *trackViewUrl, NSString *releaseNotes ,NSString *newVersion) {
        if (update) {
            
//            NSString *message = @"检测到新版本V2.01,是否更新?"; // test
                        NSString *message = [NSString stringWithFormat:@"检测到新版本V%@,是否更新?",newVersion]; //此处拼接版本号 newVersion
            [[[self alloc] init] ut_ShowUpdateAlertMessage:message toView:nil appLogo:[UIImage imageNamed:logoImageName] sureBlock:^{
                NSURL *url = [NSURL URLWithString:trackViewUrl];// 回调的地址
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            } cancleBlock:^{
                
            }];
        } else {
            NSLog(@"no");
        }
    }];


}

@end
