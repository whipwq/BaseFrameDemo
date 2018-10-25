//
//  WQImagePickerManager.m
//  WQALertSheet
//
//  Created by 温强 on 2018/4/23.
//  Copyright © 2018年 温强. All rights reserved.
//

#import "WQImagePickerManager.h"
#import "TZImagePickerController.h"
@import AVFoundation;
@import AssetsLibrary;
@import Photos;
@interface WQImagePickerManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
@end
@implementation WQImagePickerManager
static WQImagePickerManager *_imagePickerManager = nil;
+ (instancetype)sharedImagePickerManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imagePickerManager = [[WQImagePickerManager alloc] init];
    });
    return _imagePickerManager;
}
#pragma mark - 相册
- (void)openAlbumPhotos:(PickPhotoBlock)pickPhotoBlock {
    [self openAlbumPhotoCount:9 hanler:pickPhotoBlock];
}
- (void)openAlbumPhotoCount:(NSInteger)photoCount hanler:(PickPhotoBlock)pickPhotoBlock {
    self.pickPhotoBlock = pickPhotoBlock;
    TZImagePickerController * imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:photoCount delegate:self];
    imagePicker.allowPickingVideo = NO;
    imagePicker.allowTakePicture = NO;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    if (self.pickPhotoBlock) {
        self.pickPhotoBlock(photos);
    };
}
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    NSLog(@"点击取消");
}
// 选择了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    if (self.PickVideoBlock) {
        self.PickVideoBlock(coverImage);
    }
}
#pragma mark - 相机
- (void)openCamera:(TakePhotoBlock)takePhotoBlock{
    self.takePhotoBlock = takePhotoBlock;
    //是否授权访问相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [self showAlertOnController];
    } else {
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"当前为模拟器");
#elif TARGET_OS_IPHONE
        //打开相机
        [self openImagePicker];
#endif
    }
    
}
- (void)openImagePicker{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerViewDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (info) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        if (self.takePhotoBlock) {
            self.takePhotoBlock(image);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
// 点中取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)showAlertOnController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无相机访问权限"
                                                                   message:@"请在设备的 设置-隐私-相机 中允许访问相机"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    
    [alert addAction:action];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
}
@end
