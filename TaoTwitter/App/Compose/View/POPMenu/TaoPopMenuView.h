//
//  TaoPopMenuView.h
//  TaoTwitter
//
//  Created by wzt on 15/11/12.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaoPopMenuView;

@protocol TaoPopMenuViewDelegae <NSObject>
@optional
- (void)TaoPopMenuViewClick:(TaoPopMenuView *)menuView ComposeImage:(UIImageView *)composeImage;

@end

@interface TaoPopMenuView : UIView
@property(nonatomic, weak) id<TaoPopMenuViewDelegae> delegate;

- (instancetype)initWithIndex:(NSInteger)index;
@end
