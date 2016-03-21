//
//  TaoComposeKeyBoardToolBar.h
//  TaoTwitter
//
//  Created by wzt on 15/12/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaoComposeKeyBoardToolBar;
typedef enum : NSUInteger {
    TaoComposeToolbarButtonTypePicture    = 0, // 相册
    TaoComposeToolbarButtonTypeMention    = 1, // @
    TaoComposeToolbarButtonTypeTrend      = 2, // #
    TaoComposeToolbarButtonTypeEmotion    = 3, // 表情
    TaoComposeToolbarButtonTypeMore       = 4, //更多
    TaoComposeToolbarButtonTypeLocation   = 5, //显示位置
    TaoComposeToolbarButtonTypePublic     = 6,   //公开
} TaoComposeToolbarButtonType;

@protocol TaoComposeKeyBoardToolBarDelegate <NSObject>
- (void)TaoComposeKeyBoardToolBarBtnClickWithTaoComposeKeyBoardToolBar:(TaoComposeKeyBoardToolBar *)toolBar type:(TaoComposeToolbarButtonType)type;

@end

@interface TaoComposeKeyBoardToolBar : UIView
@property (nonatomic, assign) BOOL    showKeyboardButton;

@property(nonatomic, weak)IBOutlet id<TaoComposeKeyBoardToolBarDelegate> delegate;
@end
