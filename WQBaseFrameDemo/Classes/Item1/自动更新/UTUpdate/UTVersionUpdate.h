//
//  UTVersionUpdate.h
//  UTUpdater
//
//  Created by yons on 17/2/8.
//  Copyright © 2017年 陈凤林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTUpdateAlertTool.h"
@interface UTVersionUpdate : NSObject

/***********************************AFNetWorking**************************************/



/**
 * 检测版本号，提示升级
 *
 * appID:传入项目的APPID
 *
 * completion
 * update:是否需要更新
 * trackViewUrl:更新下载地址
 * releaseNotes:更新日志
 */
//+ (void)ut_checkAppVersionFromAppStoreWithAppID:(NSString *)appID completion:(void(^)(BOOL update, NSString *trackViewUrl,NSString *releaseNotes,NSString *newVersion))completion;



/**********************************原生写法***************************************/


/**
 * 检测版本号，提示升级
 *
 * appID:传入项目的APPID
 *
 * completion
 * update:是否需要更新
 * trackViewUrl:更新下载地址
 * releaseNotes:更新日志
 */

+ (void)ut_checkAppVersionFromAppStoreWithAppID:(NSString *)appID completion:(void(^)(BOOL update, NSString *trackViewUrl,NSString *releaseNotes,NSString *newVersion))completion;

@end
