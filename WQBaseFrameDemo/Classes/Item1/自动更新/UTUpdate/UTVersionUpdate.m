//
//  UTVersionUpdate.m
//  UTUpdater
//
//  Created by yons on 17/2/8.
//  Copyright © 2017年 陈凤林. All rights reserved.
//

#import "UTVersionUpdate.h"
#import "AFNetworking.h"

@implementation UTVersionUpdate

/**
 检测版本号，提示升级

 @param appID 上架的生成的appid
 @param completion 回调信息
 
 responseObject是个dic，有两个key
 KEYresultCount = 1//表示搜到一个符合你要求的APP
 results =（）//这是个只有一个元素的数组，里面都是app信息，那一个元素就是一个字典。里面有各种key。
 其中有 trackName （名称）trackViewUrl = （下载地址）version （可显示的版本号）等等
 
 */
/*
+ (void)ut_checkAppVersionFromAppStoreWithAppID:(NSString *)appID
                                     completion:(void(^)(BOOL update, NSString  *trackViewUrl,NSString *releaseNotes,NSString *newVersion))completion {
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析
        NSArray *arr = [responseObject objectForKey:@"results"];
        NSDictionary *dic = [arr firstObject];
        NSString *versionStr = [dic objectForKey:@"version"];
        NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
        NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];//更新日志
        
        if (versionStr == nil || versionStr.length == 0) {
//            versionStr = @"1.0.2";
        }
        NSString* currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        if ([currentVersion compare:versionStr] == NSOrderedDescending) {
            completion(YES, trackViewUrl,releaseNotes,versionStr);
        }else {
            completion(NO, nil, nil, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求URL失败，URL= %@",url);
    }];
}
*/

// 原生网络请求写法 参数等同



+ (void)ut_checkAppVersionFromAppStoreWithAppID:(NSString *)appID completion:(void(^)(BOOL update, NSString  *trackViewUrl,NSString *releaseNotes,NSString *newVersion))completion {
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appID];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        NSArray *arr = [responseObject objectForKey:@"results"];
        NSDictionary *dic = [arr firstObject];
        NSString *versionStr = [dic objectForKey:@"version"];
        NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
        NSString *releaseNotes = [dic objectForKey:@"releaseNotes"];
        
        if (versionStr == nil || versionStr.length == 0) {
//                        versionStr = @"4.0.5";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            if ([currentVersion compare:versionStr] == NSOrderedAscending) {
                completion(YES, trackViewUrl,releaseNotes,versionStr);
            }else {
                completion(NO, nil, nil, nil);
            }
        });
    }];
    [dataTask resume];
}


@end
