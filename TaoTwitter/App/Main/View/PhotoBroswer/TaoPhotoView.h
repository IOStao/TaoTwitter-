//
//  MJZoomingScrollView.h
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.

//

#import <UIKit/UIKit.h>

@class TaoPhotoBrowser, TaoPhotoModel, TaoPhotoView;

@protocol TaoPhotoViewDelegate <NSObject>
@optional
- (void)photoViewImageFinishLoad:(TaoPhotoView *)photoView;
- (void)photoViewSingleTap:(TaoPhotoView *)photoView;
- (void)photoViewDidEndZoom:(TaoPhotoView *)photoView;
@end

@interface TaoPhotoView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) TaoPhotoModel *photo;
// 代理
@property (nonatomic, weak) id<TaoPhotoViewDelegate> photoViewDelegate;
@end