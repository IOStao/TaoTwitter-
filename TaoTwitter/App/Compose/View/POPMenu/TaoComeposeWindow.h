//
//  TaoComeposeWindow.h
//  TaoTwitter
//
//  Created by wzt on 15/11/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    composeBtnTypeIdear            = 0 ,
    composeBtnTypeCamera           = 1 ,
    composeBtnTypeLongTwitter      = 2 ,
    composeBtnTypeSign             = 3 ,
    composeBtnTypeEvaluate         = 4 ,
    composeBtnTypeMore             = 5 ,
    composeBtnTypeFriend           = 6 ,
    composeBtnTypeTwitterCamera    = 7 ,
    composeBtnTypeMusic            = 8 ,
    composeBtnTypeShop             = 9 ,
} composeBtnType;


@protocol TaoComeposeWindowDelegate <NSObject>
@optional
- (void)TaoComeposeWindowModalVcWithType:(composeBtnType)type;

@end

@interface TaoComeposeWindow : UIWindow

@property(nonatomic, weak) id<TaoComeposeWindowDelegate> delegate;

+ (TaoComeposeWindow *)sharedInstance;
- (void)show;
- (void)removeWithAnimation:(BOOL)animation;
@end
