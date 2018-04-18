//
//  WQHttpUtil.h
//  WQBaseFrameDemo
//
//  Created by 温强 on 2018/1/20.
//  Copyright © 2018年 温强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQHttpUtil : NSObject
typedef NS_ENUM(NSInteger, NetworkReachabilityStatus) {
    NetworkReachabilityStatusUnknown   = -1,
    NetworkReachabilityStatusNotReachable  = 0,
    NetworkReachabilityStatusReachableViaWWAN = 1,
    NetworkReachabilityStatusReachableViaWiFi = 2,
};

//// GET请求
//+ (void)getWithURLString:(NSString *)URLString
//              parameters:(id)parameters
//                 success:(void (^)(id))success
//                 failure:(void (^)(NSError * error))failure;
//
//// POST请求
//+ (void)postWithURLString:(NSString *)URLString
//               parameters:(id)parameters
//                  success:(void (^)(id))success
//                  failure:(void (^)(NSError *))failure;
//// 上传图片
//+ (void)uploadWithURLString:(NSString *)URLString
//                 parameters:(id)parameters
//                 uploadData:(NSData *)uploadData
//                 uploadName:(NSString *)uploadName
//                    success:(void (^)())success
//                    failure:(void (^)(NSError *))failure;
//// 上传多张图片
//+ (void)uploadMostImageWithURLString:(NSString *)URLString
//                          parameters:(id)parameters
//                         uploadDatas:(NSArray *)uploadDatas
//                          uploadName:(NSString *)uploadName
//                             success:(void (^)())success
//                             failure:(void (^)(NSError *))failure;
//
//+(void)DownLoadWithUrlString:(NSString *)URLString
//                  parameters:(id)parameters
//                    progress:(void (^)(id))progress
//                     success:(void(^)(NSURL *filePath))success;
//
+(void)setReachabilityStatusChangeBlock:(void(^)(NetworkReachabilityStatus status))block;
//+(void)stopMonitoring;

@end
