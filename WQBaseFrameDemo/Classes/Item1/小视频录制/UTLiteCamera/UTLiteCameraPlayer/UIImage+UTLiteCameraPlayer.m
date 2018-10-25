//
//  UIImage+UTLiteCameraPlayer.m
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UIImage+UTLiteCameraPlayer.h"
@import AVFoundation;

@implementation UIImage (UTLiteCameraPlayer)

+ (UIImage *)ut_previewImageWithVideoURL:(NSURL *)videoURL {
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, asset.duration.timescale) actualTime:NULL error:nil];
    UIImage *image = [UIImage imageWithCGImage:img];
    
    CGImageRelease(img);
    return image;
}

@end
