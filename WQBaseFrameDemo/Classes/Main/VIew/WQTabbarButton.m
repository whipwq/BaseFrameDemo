//
//  WQTabbarButton.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/23.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "WQTabbarButton.h"
#import "WQBadgeValue.h"
#define ImageRidio 0.7
@interface WQTabbarButton()
@property (nonatomic, weak) WQBadgeValue *badgeView;
@end
@implementation WQTabbarButton

// 重写setHighlighted，取消高亮做的事情
- (void)setHighlighted:(BOOL)highlighted{}

// 懒加载badgeView
- (WQBadgeValue *)badgeView
{
    if (_badgeView == nil) {
        WQBadgeValue *btn = [WQBadgeValue buttonWithType:UIButtonTypeCustom];
        btn.badgeValue = self.badgeValue;
        [self addSubview:btn];
        _badgeView = btn;
    }
    return _badgeView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置字体颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}
// 传递UITabBarItem给tabBarButton,给tabBarButton内容赋值
- (void)setItem:(UITabBarItem *)item {
    _item = item;
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    // KVO：时刻监听一个对象的属性有没有改变
    // 给谁添加观察者
    // Observer:按钮
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

// 只要监听的属性一有新值，就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setTitle:_item.title forState:UIControlStateNormal];
    [self setImage:_item.image forState:UIControlStateNormal];
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    self.badgeView.badgeValue = _item.badgeValue;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    self.badgeView.badgeValue = badgeValue;
}

// 修改按钮内部子控件的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    // 1.imageView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * ImageRidio;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    // 2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageH - 3;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.bounds.size.height - titleY;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    // 3.badgeView
    self.badgeView.x = self.width - self.badgeView.width - 10;
    self.badgeView.y = 0;
}



@end
