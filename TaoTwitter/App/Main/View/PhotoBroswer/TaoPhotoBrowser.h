//
//  TaoPhotoBrowser.h
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.


#import <UIKit/UIKit.h>
#import "TaoPhotoModel.h"
@class TaoPhotoBrowser;

@protocol TaoPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(TaoPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end

@interface TaoPhotoBrowser : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) id<TaoPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
// 显示
- (void)show;
@end

