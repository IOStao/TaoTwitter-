//
//  TaoDetialRecommendView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/3.
//  Copyright © 2015年 Baidu. All rights reserved.
//
#import <Masonry.h>
#import "TaoDetialRecommendView.h"
#import "TaoRecommendTwitterView.h"
@interface TaoDetialRecommendView()
@property (nonatomic, strong) UIScrollView *recommemdView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *titleline;
@property (nonatomic, strong) NSMutableArray *twitterViews;
@property (nonatomic, strong) UIView *clearB;
@end

@implementation TaoDetialRecommendView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.twitterViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TaoRecommendTwitterView *twitterView = [[TaoRecommendTwitterView alloc] init];
            [self.recommemdView addSubview:twitterView];
            
        }];
        [self title];
        [self titleline];
        [self clearB];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        
    }
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.numberOfLines = 1;
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor tao_textLableColor];
        _title.text = @"相关推荐";
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (@(0));
            make.left.right.equalTo(@(5));
            make.height.equalTo(@(30));
        }];
    }
    return _title;
}

- (UIView *)titleline {
    if (!_titleline) {
        _titleline = [[UIView alloc] init];
        _titleline.backgroundColor = [UIColor tao_textLableColor];
        _titleline.alpha = 0.6;
        [self addSubview:_titleline];
        [_titleline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom);
            make.height.equalTo(@(0.5));
            make.left.right.equalTo(@(0));
        }];
    }
    return _titleline;
}

- (UIScrollView *)recommemdView {
    if (!_recommemdView) {
        _recommemdView = [[UIScrollView alloc] init];
        _recommemdView.pagingEnabled = YES;
        _recommemdView.showsHorizontalScrollIndicator = NO;
        _recommemdView.showsVerticalScrollIndicator = NO;
        [self addSubview:_recommemdView];
       [_recommemdView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.height.equalTo(@(84));
           make.top.equalTo(self.titleline.mas_bottom);
           make.left.right.equalTo(@(0));
       }];
    }
    return _recommemdView;
}

- (UIView *)clearB {
    if (!_clearB) {
        _clearB = [[UIView alloc] init];
        _clearB.backgroundColor = [UIColor tao_homeEditCellColor];
        [self addSubview:_clearB];
        [_clearB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(@(0));
            make.top.equalTo(self.recommemdView.mas_bottom);
            make.height.equalTo(@(7.5));
        }];
    }
    return _clearB;
}

- (NSMutableArray *)twitterViews {
    if (!_twitterViews) {
        _twitterViews = [NSMutableArray arrayWithObjects:@(1),@(2),@(3),@(4),@(5),@(6), nil];
    }
    return _twitterViews;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.recommemdView.subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[TaoRecommendTwitterView class]]) {
            TaoRecommendTwitterView *view = self.recommemdView.subviews[idx];
            view.x = idx * view.width;
            view.width = self.recommemdView.width - 50;
            view.y = 0;
            view.height = self.recommemdView.height;
        }
    }];
    self.recommemdView.contentSize = CGSizeMake(self.twitterViews.count * (self.recommemdView.width - 50), self.recommemdView.height);
    
    
}

@end
