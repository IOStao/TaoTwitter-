//
//  TaoComposeEmotionListView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeEmotionListView.h"
#import "TaoComposeEmotionCell.h"
#import "LayoutHorizontal.h"
#import "TaoComposeEmotionPlistTool.h"
#import "TaoComposeEmotionModel.h"
#import "TaoComposeEmotionListViewPopView.h"
#define maxPageEmotionCount 21

NSString * const TaoComposeEmotionCellIdentifier = @"TaoComposeEmotionCellIdentifier";
@interface TaoComposeEmotionListView()<UICollectionViewDelegate,UICollectionViewDataSource,TaoComposeEmotionCellDelegate>
@property (nonatomic, strong) NSArray *recentListView;
@property (nonatomic, strong) NSArray *defaultListView;
@property (nonatomic, strong) NSArray *emojiListView;
@property (nonatomic, strong) NSArray *lxhListView;
@property (nonatomic, strong) NSMutableArray *totalListView;
@property (nonatomic, strong) TaoComposeEmotionListViewPopView *popView;
@end

@implementation TaoComposeEmotionListView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout: (UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[TaoComposeEmotionCell class] forCellWithReuseIdentifier:TaoComposeEmotionCellIdentifier];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self  action:@selector(emotionTap:)]];
        [self totalListView];
        [self recentListView];
        [self defaultListView];
        [self emojiListView];
        [self lxhListView];
    }
    return self;
}

#pragma mark dataSource delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.totalListView.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSMutableArray *)[self.totalListView objectAtIndex:section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     TaoComposeEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TaoComposeEmotionCellIdentifier forIndexPath:indexPath];
    TaoComposeEmotionModel *emotion = [(NSArray *)[self.totalListView objectAtIndex:indexPath.section]objectAtIndex:indexPath.item];
    cell.emotion = emotion;
    cell.delegate = self;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger numer = -1;
    NSInteger numberOfPages = 0;
    NSInteger currentPages = 0;
    NSInteger groupType = 0;
    NSInteger pageNO =  (scrollView.contentOffset.x/self.width + 0.5);
    
    for (int i = 0; i < [self numberOfSectionsInCollectionView:self]; i ++) {
        
        NSInteger groupPages = [self collectionView:self numberOfItemsInSection:i] / maxPageEmotionCount;
        for (int j = 0; j < groupPages; j ++) {
            numer ++;
            if (pageNO == numer) {
                numberOfPages = groupPages;
                currentPages = j;
                groupType = i;
                break;
            }
        }
        if (pageNO == numer) break;
    }
    
    if ([self.pageDelegate respondsToSelector:@selector(TaoComposeEmotionListViewPageDataWithNumberOfPages:currentPage:)]) {
        [self.pageDelegate TaoComposeEmotionListViewPageDataWithNumberOfPages:numberOfPages currentPage:currentPages];
    }
    [TaoNotificationCenter postNotificationName:TaoComposeEmotionListViewDidScrollNotification object:nil userInfo:@{@"type":@(groupType)}];
}

- (void)TaoComposeEmotionBottomBarBtnTapWithBtnType:(TaoEmotionTabBarButtonType)type {
    NSInteger contenoOffSizeWith = 0;
    for (int i = 1; i <= type; i++) {
        contenoOffSizeWith += [self numberOfItemsInSection:i-1]/maxPageEmotionCount * self.width;
    }
    [self setContentOffset:CGPointMake(contenoOffSizeWith, 0)];
}

- (void)TaoComposeEmotionCellEmotionBtnClickWithEmotionCell:(TaoComposeEmotionCell *)cell {
    
    if (cell.emotion.isNotEmotion || cell.emotion.emotionDelete) return;
    [[TaoComposeEmotionPlistTool standard]addRecentEmotion:cell.emotion];
    [TaoNotificationCenter postNotificationName:TaoEmotionDidSelectNotification object:nil userInfo:@{TaoSelectEmotionKey:cell.emotion}];
}
#pragma maek gesture
- (void)emotionTap:(UILongPressGestureRecognizer *)longPressGesture {
    
    CGPoint location = [longPressGesture locationInView:self];
    NSIndexPath *index  = [self indexPathForItemAtPoint:location];
    
    TaoComposeEmotionCell *cell = (TaoComposeEmotionCell *)[self cellForItemAtIndexPath:index];
    switch (longPressGesture.state) {
      
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            [self.popView showFromTaoComposeEmotionCell:cell];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [self.popView removeFromSuperview];
            if (cell)[self TaoComposeEmotionCellEmotionBtnClickWithEmotionCell:cell];
            break;
        }
        default:
            break;
    }
}
         
#pragma mark getter

- (NSMutableArray *)totalListView {
    if (!_totalListView) {
        _totalListView = [NSMutableArray array];
    }
    return _totalListView;
}

- (NSArray *)recentListView {
    if (!_recentListView) {
        _recentListView = [[TaoComposeEmotionPlistTool standard]recentEmotions];
        [self.totalListView addObject:_recentListView];
    }
    return _recentListView;
}

- (NSArray *)defaultListView {
    if (!_defaultListView) {
        _defaultListView = [[TaoComposeEmotionPlistTool standard]defaultEmotions];
        [self.totalListView addObject:_defaultListView];
    }
    return _defaultListView;
}

- (NSArray *)emojiListView {
    if (!_emojiListView) {
        _emojiListView = [[TaoComposeEmotionPlistTool standard]emojiEmotions];
        [self.totalListView addObject:_emojiListView];
    }
    return _emojiListView;
}

- (NSArray *)lxhListView {
    if (!_lxhListView) {
        _lxhListView = [[TaoComposeEmotionPlistTool standard]lxhEmotions];
        [self.totalListView addObject:_lxhListView];
    }
    return _lxhListView;
}

- (TaoComposeEmotionListViewPopView *)popView {
    if (!_popView) {
        _popView = [[TaoComposeEmotionListViewPopView alloc] init];
    }
    return _popView;
}
@end
