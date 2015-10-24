//
//  NBNavigationViewController.m
//  韬微博4.0
//
//  Created by wzt on 15/10/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "NBNavigationViewController.h"
#import "TaoNavigationBarConfig.h"

@interface NBNavigationViewController ()

@end

@implementation NBNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navBarConfig configBarItems];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController<TaoNavigationBarItemHandler> *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        viewController.navBarConfig.leftButtonTitle = @"返回";
        viewController.navBarConfig.leftButtonType = TaoNavBarButtonTypeBack;
        // 设置右边的更多按钮
        if (!viewController.navBarConfig.rightButtonType) {
            viewController.navBarConfig.rightButtonType = TaoNavBarButtonTypeIconShare;
        }
    } else if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navBarConfig.leftButtonTitle = self.topViewController.title;
        viewController.navBarConfig.leftButtonType = TaoNavBarButtonTypeBack;
        
        
    }
    [super pushViewController:viewController animated:animated];
}

 #pragma mark - Rotation
 - (BOOL)shouldAutorotate {
 return NO;
 }
 
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations
 {
 return UIInterfaceOrientationMaskPortrait;
 }

#pragma private
@end
