//
//  UPDateVC.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2018/10/18.
//  Copyright © 2018年 温强. All rights reserved.
//

#import "UPDateVC.h"
#import "UTUpdateConfig.h"
@interface UPDateVC ()

@end

@implementation UPDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor yellowColor];
}
- (IBAction)btnTouch:(id)sender {
    [UTUpdateAlertTool ut_showUpdateAlertWithAppId:UTAPP_ID appLogoName:UTAPP_IMAGE_NAME];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
