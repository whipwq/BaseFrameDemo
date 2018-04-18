//
// UIViewController+RESideMenu.h
// RESideMenu
//

#import <UIKit/UIKit.h>

@class RESideMenu;

@interface UIViewController (RESideMenu)

@property (strong, readonly, nonatomic) RESideMenu *sideMenuViewController;

// IB Action Helper methods

/**
 *  调用后,展示左边控制器
 */
- (IBAction)presentLeftMenuViewController:(id)sender;

/**
 *  调用后,展示右边控制器
 */
//- (IBAction)presentRightMenuViewController:(id)sender;

@end
