//
//  NBTabBar.h
//  TaoTwitter
//
//  Created by wzt on 15/10/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBTabBar;
@protocol NBTaBarDelegate <UITabBarDelegate>
@required
- (void)PlusBtnClickWithTabBar:(NBTabBar *)tabBar;

@end

@interface NBTabBar : UITabBar
@property(nonatomic, weak) id<NBTaBarDelegate> delegate;

@end
