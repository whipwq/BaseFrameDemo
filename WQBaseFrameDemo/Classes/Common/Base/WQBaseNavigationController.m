//
//  WQBaseNavigationController.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/23.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "WQBaseNavigationController.h"

@interface WQBaseNavigationController ()

@end

@implementation WQBaseNavigationController
+ (void)initialize {
    // 获取当前类对应的UIBarButtonItem
    UIBarButtonItem *currentItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    // 设置导航栏按钮的文字颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor redColor];
    [currentItem setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
  
}
/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 此时push进来的viewController是第二个子控制器
        // 自动隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 定义全局leftBarButtonItem
//    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_topnav_black_n"]
//                                                                                       style:UIBarButtonItemStylePlain
//                                                                                      target:self
//                                                                                      action:@selector(back)];
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
