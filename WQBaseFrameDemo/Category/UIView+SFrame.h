//
//  UIView+SFrame.h
//  BootyCall
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SFrame)

/**控件的中心X*/
@property(nonatomic,assign)CGFloat                      centerX;
/**控件的中心Y*/
@property(nonatomic,assign)CGFloat                      centerY;
/**控件的X坐标*/
@property(nonatomic,assign)CGFloat                      x;
/**控件的Y坐标*/
@property(nonatomic,assign)CGFloat                      y;
/**控件的大小*/
@property(nonatomic,assign)CGSize                       size;
/**控件的位置*/
@property(nonatomic,assign)CGPoint                      origin;
/**控件的宽度*/
@property(nonatomic,assign)CGFloat                      width;
/**控件的高度*/
@property(nonatomic,assign)CGFloat                      height;

@end
