//
//  TaoDetialTwitterRepostTableViewCell.m
//  TaoTwitter
//
//  Created by wzt on 15/11/5.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoDetialTwitterRepostTableViewCell.h"
#import "TaoDetialCommentCellContentView.h"
#import <Masonry.h>

@interface TaoDetialTwitterRepostTableViewCell ()
@property (nonatomic, strong) TaoDetialCommentCellContentView *contentCellView;
@property (nonatomic, strong) UIView *line;
@end

@implementation TaoDetialTwitterRepostTableViewCell

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
        _line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(@(0));
            make.height.equalTo(@(0.5)).priorityHigh();
            make.top.equalTo(self.contentCellView.mas_bottom);
        }];
    }
    return _line;
}

- (void)setTwitter:(Taostatus *)twitter {
    [self line];
    self.contentCellView.comment = (Taocomment *)twitter;
}
@end
