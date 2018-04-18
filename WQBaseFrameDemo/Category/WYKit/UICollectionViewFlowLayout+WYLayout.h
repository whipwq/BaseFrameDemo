//
//  UICollectionViewFlowLayout+WYLayout.h
//  WildGrass
//
//  Created by 钩钩硬 on 16/6/8.
//  Copyright © 2016年 Mr.Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (WYLayout)

/**
 快速创建UICollectionViewFlowLayout

 @param itemSize item大小
 @param direction 布局方向
 @param lineSpacing 最小行间距
 @param columnSpacing 最小列间距
 
 @return UICollectionViewFlowLayout *
 */
+ (UICollectionViewFlowLayout *)createWithItemSize:(CGSize)itemSize direction:(UICollectionViewScrollDirection)direction lineSpacing:(CGFloat)lineSpacing columnSpacing:(CGFloat)columnSpacing;
/**
 快速创建UICollectionViewFlowLayout

 @param direction 布局方向
 @param lineSpacing 最小行间距
 @param columnSpacing 最小列间距
 
 @return UICollectionViewFlowLayout *
 */
+ (UICollectionViewFlowLayout *)createWithDirection:(UICollectionViewScrollDirection)direction lineSpacing:(CGFloat)lineSpacing columnSpacing:(CGFloat)columnSpacing;

@end
