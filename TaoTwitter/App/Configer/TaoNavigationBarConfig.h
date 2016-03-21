//
//  TaoNavigationBarConfig.h
//  TaoTwitter
//
//  Created by wzt on 15/10/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TaoNavBarButtonType) {
    TaoNavBarButtonTypeCustomUser           = 10,       // 用户自定义 空的.用户自主设置.
    TaoNavBarButtonTypeBack                 = 1,  // 返回箭头
    TaoNavBarButtonTypeIconShare            = 2,  // 分享图标
    TaoNavBarButtonTypeTextButton           = 3,  // 文本按钮
    TaoNavBarButtonTypeTextSubmitButton     = 4,  // 提交文本按钮，黄色
    TaoNavBarButtonTypeCancel               = 5,  // 取消
    TaoNavBarButtonTypeIconMessage          = 6,  // 消息
    TaoNavBarButtonTypeIconSetting          = 7,  // 设置
    TaoNavBarButtonTypeIconRadar            = 8,  // 雷达
    TaoNavBarButtonTypeIconFriend           = 9,  // 朋友
    TaoNavBarButtonTypeInsert               = 0, // 新建
//    TaoNavBarButtonTypeSystemBack           = 11,
};


@interface TaoNavigationBarConfig : NSObject
@property(nonatomic, assign) TaoNavBarButtonType leftButtonType;
@property(nonatomic, assign) TaoNavBarButtonType rightButtonType;
@property(nonatomic, strong) NSString* rightButtonTypeString;  //以| 隔开的，例如 2|8
@property(nonatomic, copy) NSString *leftButtonTitle;
@property(nonatomic, copy) NSString *rightButtonTitle;
@property(nonatomic) UIFont *leftButtonFont;
@property(nonatomic) UIFont *rightButtonFont;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, weak) UIViewController *viewController;

- (void)configBarItems; // 在viewDidLoad里加载一次
@end

@interface UIViewController (TaoNavigationBarConfig)
@property(nonatomic, readonly) TaoNavigationBarConfig *navBarConfig;
@end

@protocol TaoNavigationBarItemHandler <NSObject>

@optional
// type 多的话，通过 UIBarButtonItem 的tag来区分  他的tag == type
- (void)navLeftBtnClick:(id)sender;

- (void)navRightBtnClick:(id)sender;

@end
