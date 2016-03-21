//
//  TaoComposeEmotionBottomBar.h
//  TaoTwitter
//
//  Created by wzt on 15/11/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TaoEmotionTabBarButtonTypeRecent       = 0, // 最近
    TaoEmotionTabBarButtonTypeDefault      = 1, // 默认
    TaoEmotionTabBarButtonTypeEmoji        = 2, // emoji
    TaoEmotionTabBarButtonTypeLxh          = 3, // 浪小花
} TaoEmotionTabBarButtonType;


@protocol TaoComposeEmotionBottomBarDelegate <NSObject>
- (void)TaoComposeEmotionBottomBarBtnTapWithBtnType:(TaoEmotionTabBarButtonType)type;

@end

@interface TaoComposeEmotionBottomBar : UIScrollView
@property(nonatomic, weak) id<TaoComposeEmotionBottomBarDelegate> btnDelegate;

@end
