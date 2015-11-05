//
//  TaoDetialTwitterSctionHeaderView.h
//  TaoTwitter
//
//  Created by wzt on 15/11/3.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaoDetialTwitterSctionHeaderView;

typedef enum {
    TaoTwitterDetailHeaderViewTypeRetweeted,
    TaoTwitterDetailHeaderViewTypeComment,
    TaoTwitterDetailHeaderViewTypeLike,
} TaoTwitterDetailHeaderViewType;

@protocol TaoDetialTwitterSctionHeaderViewDelegate <NSObject>

@optional
- (void)TaoDetialTwitterHeaderView:(TaoDetialTwitterSctionHeaderView *)headerView TapLable:(TaoTwitterDetailHeaderViewType)lableType;

@end

@interface TaoDetialTwitterSctionHeaderView : UIView

@property (nonatomic, strong) Taostatus *twitter;
@property(nonatomic, weak) id<TaoDetialTwitterSctionHeaderViewDelegate> delegate;
@property (nonatomic, assign) TaoTwitterDetailHeaderViewType     type;
@end
