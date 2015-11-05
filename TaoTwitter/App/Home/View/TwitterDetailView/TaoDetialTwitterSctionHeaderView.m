//
//  TaoDetialTwitterSctionHeaderView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/3.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoDetialTwitterSctionHeaderView.h"
#import <Masonry.h>
/**
 *  虽然用lable 和 手势 加 约束完成了，但是做最好对lable进行封装     最好吧lab了换为按钮；
 */
@interface  TaoDetialTwitterSctionHeaderView()
@property (nonatomic, strong) UIView *celearView;
@property (nonatomic, strong) UIView *contenView;
@property (nonatomic, strong) UILabel *reweetLable;
@property (nonatomic, strong) UILabel *commentLable;
@property (nonatomic, strong) UILabel *likeLable;
@property (nonatomic, strong) UIView  *slideLine;
@property (nonatomic, strong) UIView  *line;

@end

@implementation TaoDetialTwitterSctionHeaderView

- (UIView *)celearView {
    if (!_celearView) {
        _celearView = [[UIView alloc] init];
        _celearView.backgroundColor = [UIColor tao_homeEditCellColor];
        [self addSubview:_celearView];
        [_celearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(6)).priorityHigh();
            make.top.left.right.equalTo(@(0));
        }];
    }
    return _celearView;
}

- (UIView *)contenView {
    if (!_contenView) {
        _contenView = [[UIView alloc] init];
        _contenView.backgroundColor = [UIColor whiteColor];
        [_contenView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(LableTap:)]];
        [self addSubview:_contenView];
        [_contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.celearView.mas_bottom);
            make.left.right.equalTo(@(0));
            make.height.equalTo(@(50)).priorityHigh();
        }];
    }
    return _contenView;
}

- (UIView *)slideLine {
    if (!_slideLine) {
        _slideLine = [[UIView alloc] init];
        _slideLine.backgroundColor = [UIColor orangeColor];
        [self.contenView addSubview:_slideLine];
//        [_slideLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(2));
//            make.bottom.equalTo(@(0));
//        }];
    }
    return _slideLine;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contenView.mas_bottom);
            make.bottom.left.right.equalTo(@(0));
            make.height.equalTo(@(0.5)).priorityHigh();
        }];
    }
    return _line;
}

- (UILabel *)reweetLable {
    if (!_reweetLable) {
        _reweetLable = [[UILabel alloc] init];
        _reweetLable.font = [UIFont systemFontOfSize:15];
        _reweetLable.textColor = [UIColor tao_textLableColor];
        [self.contenView addSubview:_reweetLable];
        [_reweetLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.slideLine.mas_top);
        }];
    }
    return _reweetLable;
}

- (UILabel *)commentLable {
    if (!_commentLable) {
        _commentLable = [[UILabel alloc] init];
        _commentLable.font = [UIFont systemFontOfSize:15];
        _commentLable.textColor = [UIColor tao_textLableColor];
        [self.contenView addSubview:_commentLable];
        [_commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reweetLable.mas_right).offset(15);
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.slideLine.mas_top);
        }];
    }
    return _commentLable;
}

- (UILabel *)likeLable {
    if (!_likeLable) {
        _likeLable = [[UILabel alloc] init];
        _likeLable.font = [UIFont systemFontOfSize:15];
        _likeLable.textColor = [UIColor tao_textLableColor];
        [self.contenView addSubview:_likeLable];
        [_likeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.slideLine.mas_top);
        }];
    }
    return _likeLable;
}

- (void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    [self celearView];
    [self contenView];
    [self slideLine];
    [self line];
    self.reweetLable.text = [NSString stringWithFormat:@"转发  %@",[self setupCount:twitter.reposts_count]];
    self.commentLable.text = [NSString stringWithFormat:@"评论  %@",[self setupCount:twitter.comments_count]];
    self.likeLable.text = [NSString stringWithFormat:@"赞  %@",[self setupCount:twitter.attitudes_count]];
    
    if (_twitter.comments_count) {
        self.type = TaoTwitterDetailHeaderViewTypeComment;
    }else if (_twitter.reposts_count) {
        self.type = TaoTwitterDetailHeaderViewTypeRetweeted;
    }else if (_twitter.attitudes_count){
        self.type = TaoTwitterDetailHeaderViewTypeLike;
    }else {
        self.type = TaoTwitterDetailHeaderViewTypeComment;
    }

}

- (void)setType:(TaoTwitterDetailHeaderViewType)type {
    _type = type;
    
    switch (type) {
        case TaoTwitterDetailHeaderViewTypeRetweeted: {
            
            self.reweetLable.textColor = [UIColor blackColor];
            self.commentLable.textColor = [UIColor tao_textLableColor];
            self.likeLable.textColor = [UIColor tao_textLableColor];
            [self.slideLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.reweetLable);
                make.height.equalTo(@(2)).priorityHigh();
                make.bottom.equalTo(@(0));
            }];
        }
        break;
            
        case TaoTwitterDetailHeaderViewTypeComment: {
            
            self.reweetLable.textColor = [UIColor tao_textLableColor];
            self.commentLable.textColor = [UIColor blackColor];
            self.likeLable.textColor = [UIColor tao_textLableColor];
            [self.slideLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.commentLable);
                make.height.equalTo(@(2)).priorityHigh();
                make.bottom.equalTo(@(0));
            }];
        }
            break;
            
        case TaoTwitterDetailHeaderViewTypeLike:{
            self.reweetLable.textColor = [UIColor tao_textLableColor];
            self.commentLable.textColor = [UIColor tao_textLableColor];
            self.likeLable.textColor = [UIColor blackColor];
            [self.slideLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.likeLable);
                make.height.equalTo(@(2)).priorityHigh();
                make.bottom.equalTo(@(0));
            }];

        }
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)LableTap:(UITapGestureRecognizer *)gesture {
    CGPoint  location = [gesture locationInView:self.contenView];

    if (CGRectContainsPoint(self.reweetLable.frame, location)) {
        self.type = TaoTwitterDetailHeaderViewTypeRetweeted;
    }
    else if (CGRectContainsPoint(self.commentLable.frame, location)) {
        self.type = TaoTwitterDetailHeaderViewTypeComment;
    }
    else if (CGRectContainsPoint(self.likeLable.frame, location)) {
        self.type = TaoTwitterDetailHeaderViewTypeLike;
    }
    if ([self.delegate respondsToSelector:@selector(TaoDetialTwitterHeaderView:TapLable:)]) {
        [self.delegate TaoDetialTwitterHeaderView:self TapLable:self.type];
    }
    
}

- (NSString *)setupCount:(int)count
{
    NSString *defaultTitle = nil;
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%d", count];
    }else  {
        defaultTitle = @"0";
    }
    return defaultTitle;
}

@end
