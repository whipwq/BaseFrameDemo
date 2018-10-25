//
//  UTViewController.m
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/20.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import "UTViewController.h"
#import "UTLiteCameraManager.h"
#import "UTLiteCameraPlayerViewController.h"
#import "UIImage+UTLiteCameraPlayer.h"
#import "UTButton.h"

@interface UTViewController ()

#define WIDTH  self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@property (nonatomic, copy) NSString* videoFilePath;

@end

@implementation UTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UTButton *recordingButton = [[UTButton alloc] initWithFrame:CGRectMake(50, 150, WIDTH - 100, 44)];
    [recordingButton setTitle:@"视频录制" forState:UIControlStateNormal];
    [recordingButton addTarget:self action:@selector(clickRecordingButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordingButton];
    
    UTButton *playButton = [[UTButton alloc] initWithFrame:CGRectMake(50, 250, WIDTH - 100, 44)];
    [playButton setTitle:@"视频播放" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(clickPlayButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
}
// 去录制界面
- (void)clickRecordingButton {

    //快速录制
//    [UTLiteCameraManager ut_CameraFromVC:self complete:^(NSString *filePath, NSString *message) {
//        NSLog(@"%@\n %@",filePath,message);
//        self.videoFilePath = filePath;
//        
//    }];
    
    // 自定义录制
    UTLiteCameraConfiguration *Configuration = [[UTLiteCameraConfiguration alloc] init];
    Configuration.videoMaximumDuration = 20;
    Configuration.videoFrame = CGRectMake(0, 100, WIDTH, 300);
    Configuration.themeColor = [UIColor whiteColor];
    Configuration.isSaveToPhotoLibary = YES;
    [UTLiteCameraManager ut_CameraFromVC:self configuration:Configuration complete:^(NSString *filePath, NSString *message) {
        NSLog(@"message = %@",message);
        self.videoFilePath = filePath;
    }];

    
}

// 在此为预览测试录制的视频（即初始界面播放按钮），非主要
// 去播放页
- (void)clickPlayButton {
    
    if (self.videoFilePath) {
        
        UIImage *previewImage = [UIImage ut_previewImageWithVideoURL:[NSURL fileURLWithPath:self.videoFilePath]];
        
        //文件图片和预览图不能为空
        
        UTLiteCameraPlayerViewController *playVc = [[UTLiteCameraPlayerViewController alloc] initWithVideoPath:self.videoFilePath previewImage:previewImage];
        
        [self presentViewController:playVc animated:YES completion:nil];
    } else {
        NSLog(@"文件路径为空");
    }
}

@end
