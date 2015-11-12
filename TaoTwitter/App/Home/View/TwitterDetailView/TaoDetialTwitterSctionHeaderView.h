//
//  TaoDetialTwitterSctionHeaderView.h
//  TaoTwitter
//
//  Created by wzt on 15/11/3.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaoDetialTwitterSctionHeaderView;

typedef NS_ENUM (NSInteger,TaoTwitterDetailHeaderViewType) {
    TaoTwitterDetailHeaderViewTypeRetweeted      = 0 ,
    TaoTwitterDetailHeaderViewTypeComment        = 1 ,
    TaoTwitterDetailHeaderViewTypeLike           = 2 ,
} ;

@protocol TaoDetialTwitterSctionHeaderViewDelegate <NSObject>

@optional
- (void)TaoDetialTwitterHeaderView:(TaoDetialTwitterSctionHeaderView *)headerView btnClick:(TaoTwitterDetailHeaderViewType)btnType;

@end

@interface TaoDetialTwitterSctionHeaderView : UIView

@property (nonatomic, strong) Taostatus *twitter;
@property (nonatomic, weak  ) id<TaoDetialTwitterSctionHeaderViewDelegate> delegate;
@property (nonatomic, assign) TaoTwitterDetailHeaderViewType     type;
@end
