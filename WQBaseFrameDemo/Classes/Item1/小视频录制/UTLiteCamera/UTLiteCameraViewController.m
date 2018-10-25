//
//  UTLiteCameraViewController.m
//  UTLiteCameraDemo
//
//  Created by yons on 17/2/21.
//  Copyright © 2017年 WQ. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#import "UTLiteCameraViewController.h"
#import "UTLiteCameraRecoder.h"
#import "UTLiteCameraProgressView.h"
#import "UTLiteCameraConfiguration.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ThemeColor [UIColor colorWithRed:254/255.0 green:98/255.0 blue:129/255.0 alpha:1.0]



static CGFloat UTPreviewLayerHeight = 0;

static CGFloat const UTRecordButtonWidth = 90;

@interface UTLiteCameraViewController ()<UTLiteCameraRecoderDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *outputFilePath;
@property (nonatomic) CGRect videoFrame;
@property (nonatomic, strong) NSTimer *stopRecordTimer;
@property (nonatomic, assign) CFAbsoluteTime beginRecordTime;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *focusCursor;
@property (nonatomic, strong) UTLiteCameraProgressView *progressView;

@property (nonatomic, assign) NSTimeInterval videoMaximumDuration;
@property (nonatomic, assign) NSTimeInterval videoMinimumDuration;
@property (nonatomic, copy)   CompleteBlock complete;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UTLiteCameraConfiguration *config;
@property (nonatomic, strong) UTLiteCameraRecoder *recorder;
@property (nonatomic, assign) BOOL isSaveToPhotoLibary;
@property (nonatomic, assign) BOOL UnAuthorized;
@end

@implementation UTLiteCameraViewController

#pragma mark - Init

- (instancetype)initWithConfiguration:(UTLiteCameraConfiguration *)configuration
                             complete:(CompleteBlock)complete {
    
    self = [super init];
    if(self) {
        
        _complete = complete;
        _config = configuration;
        [self matchConfigurationData];
    }
    return self;
}

// 配置外部自定义属性
- (void)matchConfigurationData {
    
    if(_config.ut_buttons.count == 3) {
        
        _playButton = _config.ut_buttons[0];
        _recordButton = _config.ut_buttons[1];
        _refreshButton = _config.ut_buttons[2];
    }
    
    if(_config.videoMaximumDuration != 0 && _config.videoMaximumDuration) {
        _videoMaximumDuration = _config.videoMaximumDuration;
    }else {
        _videoMaximumDuration = 10;
    }
    
    if(_config.videoMinimumDuration != 0 && _config.videoMinimumDuration) {
        _videoMinimumDuration = _config.videoMinimumDuration;
    }else {
        _videoMinimumDuration = 1;
    }
    
    if(_config.themeColor){
        _themeColor = _config.themeColor;
    }
    
    if(_config.filePath) {
        _outputFilePath = _config.filePath;
    }else {
        _outputFilePath = [UTLiteCameraManager ut_quickConstructFilePath];
    }
    if (_config.isSaveToPhotoLibary) {
        _isSaveToPhotoLibary = YES;
    }
    
    
    if(_config.videoFrame.size.width != 0 && _config.videoFrame.size.height != 0 ) {
        
        CGRect frame = CGRectMake(CGRectGetMinX(_config.videoFrame),CGRectGetMinY(_config.videoFrame) + 44,CGRectGetWidth(_config.videoFrame),CGRectGetHeight(_config.videoFrame));
        
        _videoFrame = frame;
    }else {
        _videoFrame = CGRectMake(0, 44, kScreenWidth, kScreenHeight);
    }
    
}


- (void)dealloc {
    [_recorder stopRunning];

}
#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(![self.recorder cameraEnable]) {
        return;
    }
    [self.recorder startRunning];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    //检测用户是否授权访问媒体设备
    [self checkAuthorization];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UTPreviewLayerHeight = ceilf(kScreenHeight - 44);
    
    self.view.backgroundColor = [UIColor blackColor];
 
    //创建视频录制对象
    self.recorder = [[UTLiteCameraRecoder alloc] initWithOutputFilePath:self.outputFilePath outputSize:self.videoFrame.size];
    //通过代理回调
    self.recorder.delegate = self;
    //初始化toolbar
    [self configToolBar];
    //初始化拍时预览界面
    [self configPreviewLayer];
    //初始化拍摄按钮
    [self configWidget];
    //初始化手动对焦
    [self configCameraFocusCursor];
    //手动对焦手势
    [self addGenstureRecognizer];
}

#pragma mark - Config 

- (void)configToolBar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    toolbar.barTintColor = [UIColor blackColor];
    toolbar.translucent = NO;
    [self.view addSubview:toolbar];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelShoot)];
    cancelItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIImage *img = _config.img_swapCamera?_config.img_swapCamera:[UIImage imageNamed:@"Camera_Turn"];
    UIBarButtonItem *transformItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(swapCamera)];
    transformItem.tintColor = [UIColor whiteColor];
    
    [toolbar setItems:@[cancelItem,flexible,transformItem]];
}

- (void)configPreviewLayer {
    
    //录制时需要获取预览显示的layer，根据情况设置layer属性，显示在自定义的界面上
    AVCaptureVideoPreviewLayer *previewLayer = [self.recorder previewLayer];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    if (self.videoFrame.size.width == 0 && self.videoFrame.size.height== 0 ) {
        previewLayer.frame = CGRectMake(0, 44, kScreenWidth, UTPreviewLayerHeight);
    } else {
        previewLayer.frame = self.videoFrame;
    }
    [self.view.layer insertSublayer:previewLayer atIndex:0];
}
// 拍摄按钮
- (void)configWidget {
    
    if(!_config.isHiddenProgressView) {
        self.progressView = [[UTLiteCameraProgressView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 5) themeColor: self.themeColor ? self.themeColor : ThemeColor duration:self.videoMaximumDuration];
        [self.view addSubview:self.progressView];
    }
    
    if(!self.recordButton) {
        
        self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recordButton setTitle:@"按住录" forState:UIControlStateNormal];
        [self.recordButton setTitleColor:self.themeColor ? self.themeColor : ThemeColor forState:UIControlStateNormal];
        self.recordButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        self.recordButton.frame = CGRectMake(kScreenWidth/2 - UTRecordButtonWidth/2, kScreenHeight - UTRecordButtonWidth - 20, UTRecordButtonWidth, UTRecordButtonWidth);
        self.recordButton.layer.cornerRadius = UTRecordButtonWidth/2;
        self.recordButton.layer.borderWidth = 3;
        self.recordButton.layer.borderColor = (self.themeColor ? self.themeColor : ThemeColor).CGColor;
        self.recordButton.layer.masksToBounds = YES;
    }
    
    if(!self.playButton) {
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.tintColor = self.themeColor ? self.themeColor : ThemeColor;
        UIImage *playImage = [[UIImage imageNamed:@"Play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.playButton setImage:playImage forState:UIControlStateNormal];
        [self.playButton sizeToFit];
        self.playButton.center = CGPointMake((kScreenWidth - UTRecordButtonWidth)/2/2, self.recordButton.center.y);
    }
    
    if(!self.refreshButton) {
        
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.refreshButton.tintColor = self.themeColor ? self.themeColor : ThemeColor;
        UIImage *refreshImage = [[UIImage imageNamed:@"Delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.refreshButton setImage:refreshImage forState:UIControlStateNormal];
        [self.refreshButton sizeToFit];
        self.refreshButton.center = CGPointMake(kScreenWidth - (kScreenWidth -UTRecordButtonWidth) / 2 / 2, self.recordButton.center.y);
    }
    
    [self recordButtonAction];
    
    [self.view addSubview:self.recordButton];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.refreshButton];
    
    self.playButton.hidden = YES;
    self.refreshButton.hidden = YES;
}

// 手动对焦设置
- (void)configCameraFocusCursor {
    
    UIImage *img = _config.img_focusCursor?_config.img_focusCursor:[UIImage imageNamed:@"focus"];
    UIImageView *focusCursor = [[UIImageView alloc]initWithImage:img];
    _focusCursor = focusCursor;
    _focusCursor.frame = CGRectMake(0, 0, 60, 45);
    if (self.videoFrame.size.width == 0 && self.videoFrame.size.height== 0 ) {
        _focusCursor.center = self.view.center;
    } else {
        _focusCursor.center = CGPointMake(CGRectGetMinX(self.videoFrame) + CGRectGetWidth(self.videoFrame) * 0.5, CGRectGetMinY(self.videoFrame) + CGRectGetHeight(self.videoFrame) *0.5);
    }
    
    [self.view addSubview:_focusCursor];
    [self.view.layer insertSublayer:_focusCursor.layer above:self.recorder.previewLayer];
}
/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
}


/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.5 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0;
        
    }];
}
#pragma - Action
// toolbar 点击取消事件
- (void)cancelShoot {
    [self.recorder stopRunning];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)swapCamera {
    //切换前后摄像头
    [self.recorder swapFrontAndBackCameras];
}

- (void)recordButtonAction {
    
    [self.recordButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [self.recordButton addTarget:self action:@selector(toggleRecording) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(buttonStopRecording) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [self.refreshButton addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendButtonAction  {
    
    [self.recordButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [self.recordButton addTarget:self action:@selector(sendVideo) forControlEvents:UIControlEventTouchUpInside];
}
// 点击删除
- (void)refreshView {
    
    [[NSFileManager defaultManager] removeItemAtPath:self.outputFilePath error:nil];
    [self.recordButton setTitle:@"按住录" forState:UIControlStateNormal];
    
    [self recordButtonAction ];
    [self.playButton setHidden:YES];
    [self.refreshButton setHidden:YES];
    
    if(!_config.isHiddenProgressView) {
        [self.progressView restore];
    }
}
// 点击拍摄预览触发事件
- (void)playVideo {
    // 获取视频第一帧图片
    UIImage *image = [UIImage ut_previewImageWithVideoURL:[NSURL fileURLWithPath:self.outputFilePath]];
    // 跳转视频播放页
    if (image == nil || self.outputFilePath == nil) {
        NSLog(@"预览图或视频路径为空");
        return;
    }
    UTLiteCameraPlayerViewController *vc = [[UTLiteCameraPlayerViewController alloc] initWithVideoPath:self.outputFilePath previewImage:image];
    [self presentViewController:vc animated:NO completion:NULL];
}

- (void)toggleRecording {
    if (![self checkAuthorization]) {
        return;
    }
    //静止自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //记录开始录制时间
    self.beginRecordTime = CACurrentMediaTime();
    //开始录制视频
    [self.recorder startRecording];
    
    if(!_config.isHiddenProgressView) {
        //进度条开始动
        [self.progressView play];
    }
}
// 停止录制
- (void)buttonStopRecording {

    [self.recorder stopRecording];
}

// 录制完成通知代理
- (void)sendVideo {
    
    if(_isSaveToPhotoLibary) {
        if (self.outputFilePath) {
            //保存视频到相簿
            UISaveVideoAtPathToSavedPhotosAlbum(self.outputFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.complete(self.outputFilePath,@"record success");
    }];
}

//视频保存到相簿后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        //[self showAlertViewWithText:@"保存到相簿失败"];
        [self showAlertViewWithText:@"保存到相簿失败" title:@"提示" action:nil];
    }
    
    
}
#pragma mark - UTShortVideoRecorderDelegate

///录制开始回调
- (void)recorderDidBeginRecording:(UTLiteCameraRecoder *)recorder {
    //录制长度限制到时间停止
    self.stopRecordTimer = [NSTimer scheduledTimerWithTimeInterval:self.videoMaximumDuration target:self selector:@selector(buttonStopRecording) userInfo:nil repeats:NO];
    [self.recordButton setTitle:@"" forState:UIControlStateNormal];
}

//录制结束回调
- (void)recorderDidEndRecording:(UTLiteCameraRecoder *)recorder {
    
    if(!_config.isHiddenProgressView) {
        //停止进度条
        [self.progressView stop];
    }
}

//视频录制结束回调
- (void)recorder:(UTLiteCameraRecoder *)recorder didFinishRecordingToOutputFilePath:(NSString *)outputFilePath error:(NSError *)error {
    //解除自动锁屏限制
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //取消计时器
    [self invalidateTime];
    
    if (error) {
        // 录制失败
        [self endRecordingWithPath:outputFilePath failture:YES];
    } else {
        //当前时间
        CFAbsoluteTime nowTime = CACurrentMediaTime();
        //拍摄时间小于规定的最小时间
        if (self.beginRecordTime != 0 && nowTime - self.beginRecordTime < self.videoMinimumDuration) {
            [self endRecordingWithPath:outputFilePath failture:NO];
        } else {
            // 录制成功完成
            self.outputFilePath = outputFilePath;
            [self.recordButton setTitle:@"完成" forState:UIControlStateNormal];
            
            //重置button状态
            [self sendButtonAction];
            self.playButton.hidden = NO;
            self.refreshButton.hidden = NO;
           
        }
        
    }
}
#pragma mark - prativeMethod
// 禁止横屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

// 定时器取消
- (void)invalidateTime {
    if ([self.stopRecordTimer isValid]) {
        [self.stopRecordTimer invalidate];
        self.stopRecordTimer = nil;
    }
}
// 手动聚焦手势触发方法
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    
    CGPoint point= [tapGesture locationInView:self.view];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.recorder.previewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self.recorder focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

- (void)endRecordingWithPath:(NSString *)path failture:(BOOL)failture {
    
    if(!_config.isHiddenProgressView) {
        [self.progressView restore];
    }
    
    [self.recordButton setTitle:@"按住拍摄" forState:UIControlStateNormal];
    
    if (failture) {
        [self showAlertViewWithText:@"录制小视频失败" title:@"生成视频失败" action:nil];
    } else {
       
        [self showAlertViewWithText:[NSString stringWithFormat:@"请长按超过%@秒钟",@(self.videoMinimumDuration)] title:@"录制小视频失败" action:nil];
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [self recordButtonAction];
}

- (void)showAlertViewWithText:(NSString *)text title:(NSString *)title action:(UIAlertAction *)action  {
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录制小视频失败" message:text preferredStyle:UIAlertControllerStyleAlert];
        if (action == nil) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
        } else {
            
            [alert addAction:action];
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
#pragma clang diagnostic pop
    }    
}

// 检测用户是否授权
- (BOOL)checkAuthorization {
    
    AVAuthorizationStatus videoAuthor = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthor = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (videoAuthor == AVAuthorizationStatusDenied || videoAuthor == AVAuthorizationStatusRestricted) {
        self.UnAuthorized = YES;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self showAlertViewWithText:@"请在设备的 设置-隐私-相机 中允许访问" title:@"媒体设备访问权限" action:action];

        return NO;
    }
    
    if( audioAuthor == AVAuthorizationStatusDenied || audioAuthor == AVAuthorizationStatusRestricted) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self showAlertViewWithText:@"请在设备的 设置-隐私-麦克风 中允许访问" title:@"媒体设备访问权限" action:action];
        return NO;
        
    }
    return YES;
}
#pragma mark -alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (self.UnAuthorized) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
