//
//  UTLiteCameraManager.m
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/22.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UTLiteCameraManager.h"
#import "UTLiteCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface UTLiteCameraManager()

@end

@implementation UTLiteCameraManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static UTLiteCameraManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[UTLiteCameraManager alloc]init];
    });
    return manager;
}
#pragma mark - Class Method

+ (NSString *)ut_getVideoFilePath {
    
    NSString *temp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];;
    temp = [temp stringByAppendingPathComponent:@"UTLiteCamera"];
    if(![UTLiteCameraManager ut_checkFileExist:temp]){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:&error];
        if(error) return nil;
    }
    return temp;
}

+ (BOOL)ut_checkFileExist:(NSString *)filePath {
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return isExist?YES:NO;
}
+ (NSString *)ut_quickConstructFilePath {
    
    NSString *path = [UTLiteCameraManager ut_getVideoFilePath];
    NSString *timeStamp = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970] * 1000 *1000];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",timeStamp]];
    return path;
}
#pragma mark - Quick Init

+ (void)ut_CameraFromVC:(UIViewController *)fromVC
               complete:(CompleteBlock)complete {
    
    [self ut_CameraFromVC:fromVC configuration:nil complete:complete];
}

+ (void)ut_CameraFromVC:(UIViewController *)fromVC configuration:(UTLiteCameraConfiguration *)configuration complete:(CompleteBlock)complete {
    
    UTLiteCameraViewController *liteCameraVC = [[UTLiteCameraViewController alloc] initWithConfiguration:configuration complete:complete];
    [fromVC presentViewController:liteCameraVC animated:YES completion:nil];
}
@end
