//
//  WQImagePickerManager.h
//  WQALertSheet
//
//  Created by 温强 on 2018/4/23.
//  Copyright © 2018年 温强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^PickPhotoBlock)(NSArray<UIImage *> *photos);
typedef void(^PickVideoBlock)(UIImage *coverImage);
typedef void(^TakePhotoBlock)(UIImage *image);
@interface WQImagePickerManager : NSObject
@property (nonatomic, copy) PickPhotoBlock pickPhotoBlock;
@property (nonatomic, copy) PickVideoBlock PickVideoBlock;
@property (nonatomic, copy) TakePhotoBlock takePhotoBlock;
/**
 打开相册 （photo count = 9）
 */
- (void)openAlbumPhotos:(PickPhotoBlock)pickPhotoBlock;
/**
 打开相册 （photo count = 1 ~ 9）
 */
- (void)openAlbumPhotoCount:(NSInteger)photoCount hanler:(PickPhotoBlock)pickPhotoBlock;
/**
 打开相机
 */
- (void)openCamera:(TakePhotoBlock)takePhotoBlock;

+ (instancetype)sharedImagePickerManager;
@end
