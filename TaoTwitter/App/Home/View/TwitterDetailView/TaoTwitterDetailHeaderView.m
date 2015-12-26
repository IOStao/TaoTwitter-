//
//  TaoTwitterDetailHeaderView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/2.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterDetailHeaderView.h"
#import "TaoTwitterStatusView.h"
#import "TaoTwitterRStatusView.h"
#import "TaoDetialRecommendView.h"
#import <Masonry.h>

@interface TaoTwitterDetailHeaderView ()
@property (nonatomic, strong)  TaoTwitterStatusView *statusView;
@property (nonatomic, strong)  TaoTwitterRStatusView *rStatusView;
@property (nonatomic, strong)  UIView *backGroundView;
@property (nonatomic, strong)  TaoDetialRecommendView *detialRecommendView;
@property (nonatomic, strong)  UIView *line;

@end

@implementation TaoTwitterDetailHeaderView

- (TaoTwitterStatusView *)statusView {
    if (!_statusView) {
        _statusView = [[TaoTwitterStatusView alloc]init];
        [self.backGroundView addSubview:_statusView];
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@(0));
        }];
    }
    return _statusView;
}

- (TaoTwitterRStatusView *)rStatusView {
    if (!_rStatusView) {
        _rStatusView = [[TaoTwitterRStatusView alloc] init];
        [self.backGroundView addSubview:_rStatusView];
    }
    return _rStatusView;
}

- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        [self.contentView addSubview:_backGroundView];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@(0));
        }];
    }
    return _backGroundView;
}

- (TaoDetialRecommendView *)detialRecommendView {
    if (!_detialRecommendView) {
        _detialRecommendView = [[TaoDetialRecommendView alloc] init];
        _detialRecommendView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_detialRecommendView];
        [_detialRecommendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.mas_bottom).offset(15);
            make.bottom.right.left.equalTo(@(0));
        }];
    }
    return _detialRecommendView;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(@(0));
            make.top.equalTo(self.backGroundView.mas_bottom);
        }];
    }
    return _line;
}

- (void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    
    [self statusView];
    [self rStatusView];
    [self detialRecommendView];
    [self line];
//    self.statusView.twitter = twitter;
    
    if (twitter.retweeted_status) {
        self.rStatusView.hidden = NO;
//        self.rStatusView.twitter = twitter.retweeted_status;
        [_rStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusView.mas_bottom).offset(10);
            make.left.right.equalTo(@(0));
            make.bottom.equalTo(@(-5)).priorityHigh();
            
        }];
    } else {
        self.rStatusView.hidden = YES;
        [_rStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
            make.top.equalTo(self.statusView.mas_bottom).offset(0);
            make.bottom.equalTo(@(-5)).priorityHigh();
        }];
    }
    
}

#warning 有数据了加入接口推荐

@end
