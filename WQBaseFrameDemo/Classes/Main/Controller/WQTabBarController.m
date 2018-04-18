//
//  WQTabBarController.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/23.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "WQTabBarController.h"
#import "WQBaseNavigationController.h"
#import "WQTempItem1.h"
#import "WQTempItem2.h"
#import "WQTempItem3.h"
#import "WQTempItem4.h"
#import "WQTabBar.h"
@interface WQTabBarController ()<WQTabBarDelegate>
/** 定义保存item的数组 */
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) WQTabBar *myTabbar;
@end
#pragma mark - temp
static int badgeNum = 0;
@implementation WQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self setupChildViewController];
    // 自定义tabbar
    [self setUpTabBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBadge) name:@"addBadge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanBadge) name:@"cleanBadge" object:nil];
}
- (void)addBadge {
    badgeNum ++;
    NSString *badgeValue = [NSString stringWithFormat:@"%d",badgeNum];
    WQTabbarButton *btn = self.myTabbar.buttons[0];
    btn.badgeValue = badgeValue;
}
- (void)cleanBadge {
    WQTabbarButton *btn = self.myTabbar.buttons[0];
    badgeNum = 0;
    btn.badgeValue = @"";
}
#pragma mark - WQTabBarDelegate
// 点击了中间按钮的代理方法
- (void)tabBarDidClickPlusButton:(WQTabBar *)tabBar {

}
// 点击了其他tabBar按钮的代理方法
- (void)tabBar:(WQTabBar *)tabBar didCilckButton:(NSInteger)index {
    self.selectedIndex = index;
}

#pragma mark - 自定义tabBar
- (void)setUpTabBar {
    self.myTabbar = [[WQTabBar alloc] initWithFrame:self.tabBar.frame];
    self.myTabbar.backgroundColor = [UIColor whiteColor];
    self.myTabbar.tabBarDelegate = self;
    self.myTabbar.tabBaritems = self.items;
    [self setValue:self.myTabbar forKeyPath:@"tabBar"];
    
}
#pragma mark - 添加子控制器
/**
 * 添加子控制器
 */
- (void)setupChildViewController {
    
    WQTempItem1 *item1 = [[WQTempItem1 alloc] init];
    [self addChildVc:item1 title:@"Item1" image:@"common_mainbav_my_n" selectedImage:@"common_mainbav_my_s"];
    
    WQTempItem2 *item2 = [[WQTempItem2 alloc] init];
    [self addChildVc:item2 title:@"Item2" image:@"common_mainbav_project_n" selectedImage:@"common_mainbav_project_s"];
    
    WQTempItem3 *item3 = [[WQTempItem3 alloc] init];
    [self addChildVc:item3 title:@"Item3" image:@"common_mainbav_cloud_n" selectedImage:@"common_mainbav_cloud_s"];
    
    WQTempItem4 *item4 = [[WQTempItem4 alloc] init];
    [self addChildVc:item4 title:@"Item4" image:@"common_mainbav_massage_n" selectedImage:@"common_mainbav_massage_s"];
}
/**
 *  添加一个子控制器
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //保存到数组
    //[self.childVCs addObject:childVc.tabBarItem];
    // 为子控制器包装导航控制器
    WQBaseNavigationController *navVc = [[WQBaseNavigationController alloc] initWithRootViewController:childVc];
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    // 关闭系统导航的侧滑效果 避免与变菜单侧滑效果冲突
    navVc.interactivePopGestureRecognizer.enabled = NO;
    navVc.interactivePopGestureRecognizer.delegate = nil;
    // 添加子控制器
    [self addChildViewController:navVc];
    [self.items addObject:childVc.tabBarItem];
}
#pragma mark - lazy
- (NSMutableArray *)items {
    if (nil == _items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
@end
