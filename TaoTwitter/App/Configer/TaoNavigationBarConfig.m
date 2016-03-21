//
//  TaoNavigationBarConfig.m
//  TaoTwitter
//
//  Created by wzt on 15/10/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoNavigationBarConfig.h"
#import <objc/runtime.h>

@interface TaoNavigationBarConfig()
@property (nonatomic, readonly) UINavigationBar *navigationBar;

@end

@implementation TaoNavigationBarConfig
- (instancetype)initWithViewController:(UIViewController *)vc {
    if (self = [super init]) {
        self.viewController = vc;
    }
    return self;
}

#pragma mark - Setters

- (void)configBarItems {
    // Navigation bar items
    UINavigationItem *item = self.viewController.navigationItem;
    item.backBarButtonItem = nil;
    if (!item.leftBarButtonItem) {
        item.leftBarButtonItem =
        [self navBarItemWithType:self.leftButtonType
                           title:self.leftButtonTitle
                            font:self.leftButtonFont
                        selector:@selector(navLeftBtnClick:)];
    }
    
    if (!item.rightBarButtonItem) {
        item.rightBarButtonItem =
        [self navBarItemWithType:self.rightButtonType
                                                     title:self.rightButtonTitle
                                                      font:self.rightButtonFont
                                                  selector:@selector(navRightBtnClick:)];
        }
}
- (void)setRightButtonTypeString:(NSString *)rightButtonTypeString
{
    _rightButtonTypeString = rightButtonTypeString;
    _rightButtonType = -1; // 为了躲过 == TaoNavBarButtonTypeCustom ，而不执行下面的代码
}
- (void)setTitle:(NSString *)title {
    self.viewController.navigationItem.title = title;
}

- (NSString *)title {
    return self.viewController.navigationItem.title;
}

- (UINavigationBar *)navigationBar {
    return self.viewController.navigationController.navigationBar;
}

- (UIBarButtonItem *)navBarItemWithType:(TaoNavBarButtonType)type
                                  title:(NSString *)title
                                   font:(UIFont *)font
                               selector:(SEL)selector {
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:selector type:type title:title];
    if (font) {
        [item setTitleTextAttributes:@{NSFontAttributeName: font} forState:UIControlStateNormal];
    }
    return item;
}

- (void)navLeftBtnClick:(id)sender {
    if ([self.viewController respondsToSelector:@selector(navLeftBtnClick:)]) {
        [(UIViewController<TaoNavigationBarItemHandler> *)self.viewController navLeftBtnClick:sender];
    } else if (self.leftButtonType == TaoNavBarButtonTypeBack) {
        if (self.viewController.navigationController) {
            [self.viewController.navigationController popViewControllerAnimated:YES];
        } else {
            [self.viewController dismissViewControllerAnimated:YES completion:NULL];
        }
    }
}

- (void)navRightBtnClick:(id)sender {
    if ([self.viewController respondsToSelector:@selector(navRightBtnClick:)]) {
        [(UIViewController<TaoNavigationBarItemHandler> *)self.viewController navRightBtnClick:sender];
    }
}

@end

@implementation UIViewController (TaoNavigationBarConfig)

- (TaoNavigationBarConfig *)navBarConfig {
    id config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        config = [[TaoNavigationBarConfig alloc] initWithViewController:self];
        objc_setAssociatedObject(self, _cmd, config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return config;
}

@end

