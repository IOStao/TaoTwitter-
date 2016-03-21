//
//  TaoComposeKeyBoardInputView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeKeyBoardInputView.h"
#import "TaoComposeEmotionListView.h"
#import "LayoutHorizontal.h"
#import <Masonry/Masonry.h>
#import "TaoComposeEmotionBottomBar.h"

#define  TaoComposeKeyBoardInputViewHeight 216
#define pageControlHeight 25
#define showScrollViewHeight 37
#define collectionViewHieght (self.height - pageControlHeight - showScrollViewHeight)

@interface TaoComposeKeyBoardInputView ()<TaoComposeEmotionListViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, weak) TaoComposeEmotionListView *listView;
@property (nonatomic, strong) TaoComposeEmotionBottomBar *bottomBar;
@property (nonatomic, strong) UIView  *line;
@property (nonatomic, strong) UILabel *recentEmotionLable;
@end

@implementation TaoComposeKeyBoardInputView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor nb_colorWithHex:0xf9f9f9];
        self.width = TaoScreenWidth;
        self.height = TaoComposeKeyBoardInputViewHeight;//外面约束加。
        [self configerEmotionScrollView];
            }
    return self;
}

- (void)configerEmotionScrollView {
    LayoutHorizontal *layout = [[LayoutHorizontal alloc] init];
    layout.totalRow = 3;
    layout.totalColum = 7;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.itemSize = CGSizeMake((self.width - 2 * 20) / layout.totalColum, collectionViewHieght / layout.totalRow);
    
    TaoComposeEmotionListView *listview = [[TaoComposeEmotionListView alloc] initWithFrame:CGRectMake(0, 0, self.width, collectionViewHieght) collectionViewLayout:layout];
    self.listView = listview;
    self.listView.pageDelegate = self;
    [self addSubview:listview];
    [listview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.height.equalTo(@(collectionViewHieght));
    }];
    
    [self pageControl];
    [self recentEmotionLable];
    [self line];
    [self bottomBar];
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        // 当只有1页时，自动隐藏pageControl
        _pageControl.userInteractionEnabled = NO;
        // 设置内部的圆点图片
        [_pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        
        [self addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.listView.mas_bottom);
            make.height.equalTo(@(pageControlHeight));
            make.left.right.equalTo(@(0));
        }];
    }
    return _pageControl;
}

- (TaoComposeEmotionBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[TaoComposeEmotionBottomBar alloc] init];
        [self addSubview:_bottomBar];
        _bottomBar.btnDelegate = self.listView;
        _bottomBar.backgroundColor = [UIColor clearColor];
      
        
        [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@(0));
            make.bottom.equalTo(@(0));
            make.top.equalTo(self.line.mas_bottom);
        }];
    }
    return _bottomBar;
}

- (UIView *)line {
    if (!_line ) {
        _line = [[UIView  alloc] init];
        [self addSubview:_line];
        _line.backgroundColor = TaoColor(224, 224, 224, 1);
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@(0));
            make.top.equalTo(self.pageControl.mas_bottom);
            make.height.equalTo(@(0.5));
        }];
    }
    return _line;
}

- (UILabel *)recentEmotionLable {
    if (!_recentEmotionLable) {
        _recentEmotionLable = [[UILabel alloc] init];
        _recentEmotionLable.text = @"最近使用的表情";
        _recentEmotionLable.textColor = [UIColor lightGrayColor];
        _recentEmotionLable.textAlignment = NSTextAlignmentCenter;
        _recentEmotionLable.font = [UIFont systemFontOfSize:13];
        [_pageControl addSubview:_recentEmotionLable];
        [_recentEmotionLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(@(0));
        }];
    }
    return _recentEmotionLable;
}
#pragma mark delegate

- (void)TaoComposeEmotionListViewPageDataWithNumberOfPages:(NSInteger)numberOfPages currentPage:(NSInteger)currentPage {
    if (numberOfPages > 1) {
        self.recentEmotionLable.hidden = YES;
        self.pageControl.numberOfPages = numberOfPages;
        self.pageControl.currentPage = currentPage;
      
    }else {
        _pageControl.numberOfPages = 0;
        self.recentEmotionLable.hidden = NO;
    }
}

@end
