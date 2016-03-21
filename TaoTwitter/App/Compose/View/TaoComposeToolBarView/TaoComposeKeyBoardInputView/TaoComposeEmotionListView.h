//
//  TaoComposeEmotionListView.h
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoComposeEmotionBottomBar.h"

@protocol TaoComposeEmotionListViewDelegate <NSObject>
@optional
- (void)TaoComposeEmotionListViewPageDataWithNumberOfPages:(NSInteger)numberOfPages currentPage:(NSInteger)currentPage;
@end

@interface TaoComposeEmotionListView : UICollectionView <TaoComposeEmotionBottomBarDelegate>
@property(nonatomic, weak) id<TaoComposeEmotionListViewDelegate>  pageDelegate;

@end
