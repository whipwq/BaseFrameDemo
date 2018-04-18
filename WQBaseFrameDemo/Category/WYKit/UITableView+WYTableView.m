//
//  UITableView+WYTableView.m
//  UChat
//
//  Created by 钩钩硬 on 16/1/21.
//  Copyright © 2016年 dcj. All rights reserved.
//

#import "UITableView+WYTableView.h"

@implementation UITableView (WYTableView)

+ (UITableView *)tableWithFrame:(CGRect)frame style:(UITableViewStyle)style superView:(UIView *)superView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    [superView addSubview:tableView];
    return tableView;
}

@end
