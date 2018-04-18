//
//  WQTabBar.h
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/23.
//  Copyright © 2017年 温强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQTabbarButton.h"
@class WQTabBar;

@protocol WQTabBarDelegate <UITabBarDelegate>

@optional
/**
 *  点击中间加号按钮的时候调用
 */
- (void)tabBarDidClickPlusButton:(WQTabBar *)tabBar;
/**
 *  点击tabBar的按钮调用
 */
- (void)tabBar:(WQTabBar *)tabBar didCilckButton:(NSInteger)index;

@end

@interface WQTabBar : UITabBar
/** 新的按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSArray *tabBaritems;
@property (nonatomic, weak) id<WQTabBarDelegate> tabBarDelegate;
@end
