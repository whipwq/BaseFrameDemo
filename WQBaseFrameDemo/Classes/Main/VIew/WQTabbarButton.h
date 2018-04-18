//
//  WQTabbarButton.h
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/23.
//  Copyright © 2017年 温强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQTabbarButton : UIButton
/**
 *  定义UITabBarItem按钮属性,便于给item赋值
 */
@property (nonatomic, strong) UITabBarItem *item;
/**
 *  badgeValue的值
 */
@property (nonatomic, copy) NSString *badgeValue;
@end
