//
//  UITableView+WYTableView.h
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WYTableView)
/**
 快速创建tableview

 @param frame frame
 @param style 风格
 @param superView 其父视图
 
 @return UITableView *
 */
+ (UITableView *)tableWithFrame:(CGRect)frame style:(UITableViewStyle)style superView:(UIView *)superView;

@end
