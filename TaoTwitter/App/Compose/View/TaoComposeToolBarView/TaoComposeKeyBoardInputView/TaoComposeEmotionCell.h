//
//  TaoComposeEmotionCell.h
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaoComposeEmotionModel,TaoComposeEmotionCell;

@protocol TaoComposeEmotionCellDelegate <NSObject>
@optional
- (void)TaoComposeEmotionCellEmotionBtnClickWithEmotionCell:(TaoComposeEmotionCell *)cell ;

@end

@interface TaoComposeEmotionCell : UICollectionViewCell
@property (nonatomic, strong) TaoComposeEmotionModel *emotion;
@property (nonatomic, weak) id<TaoComposeEmotionCellDelegate> delegate;
@end
