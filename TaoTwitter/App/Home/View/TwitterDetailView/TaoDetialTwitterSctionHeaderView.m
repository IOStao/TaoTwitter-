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
@property (nonatomic, strong) UIButton *reweetBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIView  *slideLine;
@property (nonatomic, strong) UIView  *line;
@property (nonatomic, weak)   UIButton *selectedBtn;

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
        [self addSubview:_contenView];
        [_contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.celearView.mas_bottom);
            make.left.right.equalTo(@(0));
            make.height.equalTo(@(45)).priorityHigh();
        }];
    }
    return _contenView;
}

- (UIView *)slideLine {
    if (!_slideLine) {
        _slideLine = [[UIView alloc] init];
        _slideLine.backgroundColor = [UIColor orangeColor];
        [self.contenView addSubview:_slideLine];
        
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

- (UIButton *)reweetBtn {
    if (!_reweetBtn) {
        _reweetBtn = [[UIButton alloc] init];
        _reweetBtn.tag = TaoTwitterDetailHeaderViewTypeRetweeted;
        [self.contenView addSubview:_reweetBtn];
        [_reweetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.slideLine.mas_top);
        }];
    }
    return _reweetBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        _commentBtn.tag = TaoTwitterDetailHeaderViewTypeComment;
        [self.contenView addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reweetBtn.mas_right).offset(15);
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.slideLine.mas_top);
        }];
    }
    return _commentBtn;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] init];
        [self.contenView addSubview:_likeBtn];
        _likeBtn.tag = TaoTwitterDetailHeaderViewTypeLike;
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.top.equalTo(@(0));
            make.bottom.equalTo(self.slideLine.mas_top);
        }];
    }
    return _likeBtn;
}

- (void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    [self celearView];
    [self contenView];
    [self slideLine];
    [self line];
    
    [self setupBtnTitle:self.reweetBtn count:twitter.reposts_count defaultTitle:@"转发"];
    [self setupBtnTitle:self.commentBtn count:twitter.comments_count defaultTitle:@"评论"];
    [self setupBtnTitle:self.likeBtn count:twitter.attitudes_count defaultTitle:@"赞"];
}

- (void)setDelegate:(id<TaoDetialTwitterSctionHeaderViewDelegate>)delegate {
    _delegate = delegate;
    if (_twitter.comments_count) {
        [self btnClick:self.commentBtn];
    }else if (_twitter.reposts_count) {
        [self btnClick:self.reweetBtn];
    }else if (_twitter.attitudes_count) {
        [self btnClick:self.likeBtn];
    }else {
        [self btnClick:self.commentBtn];
    }
}

- (void)setupBtnTitle:(UIButton *)button count:(int)count defaultTitle:(NSString *)defaultTitle {
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%@  %.1f万", defaultTitle, count / 10000.0];
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%@  %d ", defaultTitle, count];
    } else {
        defaultTitle = [NSString stringWithFormat:@"%@  0", defaultTitle];
    }
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:defaultTitle forState:UIControlStateNormal];
    [button setTitle:defaultTitle forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor tao_textLableColor] forState:UIControlStateNormal];
    [button addTarget:self  action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)btn {
    self.type = btn.tag;
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    [_slideLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2)).priorityHigh();
        make.bottom.equalTo(@(0));
        make.left.right.equalTo(btn);
    }];
    

    [UIView animateWithDuration:0.35 animations:^{
        self.slideLine.centerX = btn.centerX;
    }];
    
    if ([self.delegate respondsToSelector:@selector(TaoDetialTwitterHeaderView:btnClick:)]) {
        [self.delegate TaoDetialTwitterHeaderView:self btnClick:self.type];
    }
}
@end
