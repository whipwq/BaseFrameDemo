//
//  WQTabBar.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/23.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "WQTabBar.h"

@interface WQTabBar()
/** 中间按钮 */
@property (nonatomic, weak) UIButton *plusButton;
/** 记录当前选中按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 想设置tabbar背景 打开*/
@property (nonatomic, strong) UIView *containView;
@end
@implementation WQTabBar
- (instancetype)init {
    if (self = [super init]) {
        [self removeAllSubViews];
    }
    return self;
}
#pragma mark - 懒加载
- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}
//- (UIView *)containView {
//    if (nil == _containView) {
//        _containView = [[UIView alloc] init];
//        _containView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 49);
//        _containView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:_containView];
//    }
//    return _containView;
//}
- (UIButton *)plusButton {
    if (_plusButton == nil) {
        
        // 创建一个button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:@"common_mainbav_built_n"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"common_mainbav_built_p"] forState:UIControlStateHighlighted];
        // 设置尺寸自适应
        [btn sizeToFit];
        
        // 监听按钮的点击
        [btn addTarget:self action:@selector(didClickPlusBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _plusButton = btn;
        
        [self addSubview:_plusButton];
        
    }
    return _plusButton;
}

- (void)setTabBaritems:(NSArray *)tabBaritems {
    
    _tabBaritems = tabBaritems;
    
}
#pragma mark - 按钮的点击事件
// 监听按钮的点击事件
- (void)didClickButton:(UIButton *)button {
    //    DXLog(@"点击了第%ld个按钮", (long)button.tag);
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    
    // 通知tabBar切换控制器  调用代理方法
    if ([_tabBarDelegate respondsToSelector:@selector(tabBar:didCilckButton:)]) {
        [_tabBarDelegate tabBar:self didCilckButton:button.tag];
    }
    
}

// 中间按钮的点击事件  调用代理方法
- (void)didClickPlusBtn {
    //    DXLog(@"点击了中间按钮");
    // modal出控制器
    if ([_tabBarDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [_tabBarDelegate tabBarDidClickPlusButton:self];
    }
    
}


#pragma mark - 布局控件
// 布局控件
- (void)layoutSubviews {
    if (self.buttons.count) {
        return;
    }
    [super layoutSubviews];
    [self removeAllSubViews];
    // 遍历模型数组,创建按钮
    for (UITabBarItem *item in _tabBaritems) {
        WQTabbarButton *button = [WQTabbarButton buttonWithType:UIButtonTypeCustom];
        // 给按钮赋值模型，按钮的内容由模型对应决定
        button.item = item;
        // 绑定tag,
        button.tag = self.buttons.count;
        // 监听按钮的点击事件
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchDown];
        // 如果是第0个, 直接调用一次
        if (button.tag == 0) {
            [self didClickButton:button];
        }
        // 把按钮添加控件上
        [self addSubview:button];
        // 把按钮添加到按钮数组
        [self.buttons addObject:button];
        
    }
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / (self.items.count + 1);
    CGFloat btnH = h;
    int i = 0; // 将按钮索引初始化0
    for (UIView *tabBarButton in self.buttons) {
        // 让索引为2的时候就是中间,这时候就让i跳过
        if (i == 2) {
            i = 3;
        }
        btnX = i * btnW;
        tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }
    
    // 设置中间按钮的位置
    self.plusButton.center = CGPointMake(w * 0.5, h * 0.5);
}


@end
