//
//  UTLiteCameraPlayerView.h
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTLiteCameraPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoPath:(NSString *)videoPath previewImage:(UIImage *)previewImage;

- (void)play;

- (void)pause;

@end
