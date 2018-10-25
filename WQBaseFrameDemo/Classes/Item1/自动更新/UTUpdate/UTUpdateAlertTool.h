//
//  UTUpdateAlertTool.h
//  UTAlertTool
//
//  Created by yons on 17/2/8.
//  Copyright © 2017年 温强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UTUpdateAlertTool : NSObject

typedef void(^SureBlock)();
typedef void(^CancleBlock)();



/**
 检查更新
 
 @param appid 应用id
 @param logoImageName logoImageName description
 */
+ (void)ut_showUpdateAlertWithAppId:(NSString *)appid appLogoName:(NSString *)logoImageName;
@end
