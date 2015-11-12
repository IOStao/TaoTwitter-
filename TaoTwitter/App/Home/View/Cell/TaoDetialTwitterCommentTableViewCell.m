//
//  TaoDetialTwitterTableViewCell.m
//  TaoTwitter
//
//  Created by wzt on 15/11/5.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoDetialTwitterCommentTableViewCell.h"
#import "TaoDetialCommentCellContentView.h"
#import <Masonry.h>

@interface TaoDetialTwitterCommentTableViewCell ()
@property (nonatomic, strong) TaoDetialCommentCellContentView *contentCellView;
@property (nonatomic, strong) UIView *line;
@end

@implementation TaoDetialTwitterCommentTableViewCell

- (TaoDetialCommentCellContentView *)contentCellView {
    if (!_contentCellView) {
        _contentCellView  = [[TaoDetialCommentCellContentView alloc] init];
        [self.contentView addSubview:_contentCellView];
        [_contentCellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@(0));
        }];
    }
    return _contentCellView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor tao_textLableColor];
        _line.alpha = 0.6;
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(@(0));
            make.height.equalTo(@(0.5)).priorityHigh();
            make.top.equalTo(self.contentCellView.mas_bottom);
        }];
    }
    return _line;
}

- (void)setComment:(Taocomment *)comment {
    _comment = comment;
    [self line];
    self.contentCellView.comment = comment;
}
@end
