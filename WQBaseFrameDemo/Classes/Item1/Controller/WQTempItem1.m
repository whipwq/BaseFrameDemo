//
//  WQTempItem1.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/24.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "WQTempItem1.h"
#import "RESideMenu.h"
@interface WQTempItem1 ()

@end

@implementation WQTempItem1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clouddisk_search_up_n"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
}
- (IBAction)addBadge:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addBadge" object:nil];
}
- (IBAction)cleanBadge:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanBadge" object:nil];
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
