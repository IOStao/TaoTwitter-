//
//  TaoHomeTitleBtn.h
//  韬微博4.0
//
//  Created by wzt on 15/10/21.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaoHomeTitleMenu;
@interface TaoHomeTitleBtn : UIButton

+ (instancetype)TitleBtnWithTitle:(NSString *)title;
@end

@protocol TaoHomeTitleMenuDelegate <NSObject>


@end

@interface TaoHomeTitleMenu : UIWindow
@property (nonatomic, assign) CGFloat     MaxY;
@property(nonatomic, weak) id<TaoHomeTitleMenuDelegate> delegate;

+ (TaoHomeTitleMenu *)sharedInstance;
- (void)show;
- (void)remove;
@end