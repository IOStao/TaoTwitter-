//
//  TaoRecommendTwitterView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/3.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoRecommendTwitterView.h"
#import <Masonry.h>

@interface TaoRecommendTwitterView ()
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *detialTitle;
@property (nonatomic, strong) UILabel *source;
@property (nonatomic, strong) UIView *rightLine;
@end

@implementation TaoRecommendTwitterView

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [self addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (@(12));
            make.bottom.equalTo(@(-12)).priorityHigh();
            make.left.equalTo(@(10));
            make.width.equalTo(@(60)).priorityHigh();
        }];
    }
    return _image;
}

- (UILabel *)detialTitle {
    if (!_detialTitle) {
        _detialTitle = [[UILabel alloc]init];
        _detialTitle.numberOfLines = 2;
        _detialTitle.font = [UIFont systemFontOfSize:13];
        _detialTitle.text = @"测试，测试，sdkjfhkjsdhkfhsldkfh";
        [self addSubview:_detialTitle];
        [_detialTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.mas_right).offset(10);
            make.top.equalTo(self.image.mas_top);
            make.right.equalTo(self.rightLine.mas_left).offset(20);
        }];
    }
    return _detialTitle;
}

- (UILabel *)source {
    if (!_source) {
        _source = [[UILabel alloc] init];
        _source.font  = [UIFont systemFontOfSize:10];
        _source.numberOfLines = 1;
        _source.textColor = [UIColor tao_textLableColor];
        _source.text = @"来源于: wuzhentao";
        [self addSubview:_source];
        [_source mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detialTitle.mas_left);
            make.right.equalTo(self.detialTitle.mas_right);
            make.bottom.equalTo(self.image.mas_bottom);
        }];
    
    }
    return _source;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = [UIColor tao_textLableColor];
        _rightLine.alpha = 0.6;
        [self addSubview:_rightLine];
        [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0.5)).priorityHigh();
            make.top.equalTo(@(12));
            make.bottom.equalTo(@(-12)).priorityHigh();
            make.right.equalTo(@(0));
        }];
    }
    return _rightLine;
}
#warning 等待数据

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self image];
        [self source];
        [self rightLine];
    }
    return self;
}
@end
