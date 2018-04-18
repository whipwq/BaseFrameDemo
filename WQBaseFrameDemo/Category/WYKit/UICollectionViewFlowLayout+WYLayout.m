//
//  UICollectionViewFlowLayout+WYLayout.m
//  WildGrass
//
//  Created by 钩钩硬 on 16/6/8.
//  Copyright © 2016年 Mr.Yu. All rights reserved.
//

#import "UICollectionViewFlowLayout+WYLayout.h"

@implementation UICollectionViewFlowLayout (WYLayout)

+ (UICollectionViewFlowLayout *)createWithItemSize:(CGSize)itemSize direction:(UICollectionViewScrollDirection)direction lineSpacing:(CGFloat)lineSpacing columnSpacing:(CGFloat)columnSpacing {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = itemSize;
    layout.scrollDirection = direction;
    layout.minimumInteritemSpacing = lineSpacing;
    layout.minimumLineSpacing = columnSpacing;

    return layout;
}

+ (UICollectionViewFlowLayout *)createWithDirection:(UICollectionViewScrollDirection)direction lineSpacing:(CGFloat)lineSpacing columnSpacing:(CGFloat)columnSpacing {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = direction;
    layout.minimumInteritemSpacing = lineSpacing;
    layout.minimumLineSpacing = columnSpacing;
    return layout;
}

@end
