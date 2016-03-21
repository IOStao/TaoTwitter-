//
//  TaoDetialCommentCellView.m
//  Taocomments
//
//  Created by wzt on 15/11/5.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Masonry.h>
#import "TaoDetialCommentCellContentView.h"
#import "TaoTwitterTextLable.h"
#import <YYWebImage/YYWebImage.h>
#import "TaoTwitterTextLableRegexKitLiteTool.h"

@interface TaoDetialCommentCellContentView ()
@property (strong, nonatomic)  UIImageView *userImage;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic)  UIImageView *vipImage;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *statues;
@property (nonatomic, strong)  UIImageView *like;

@end

@implementation TaoDetialCommentCellContentView

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = [[UIImageView alloc]init];
        [self addSubview:_userImage];
        [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(40));
            make.width.equalTo(@(40));
            make.left.equalTo(@(10));
            make.top.equalTo(@(10));
        }];
    }
    return _userImage;
}

- (UILabel *)userName {
    if (!_userName ) {
        _userName = [[UILabel alloc] init];
        _userName.font = [UIFont systemFontOfSize:15];
        [self addSubview:_userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userImage.mas_right).offset(8);
            make.top.equalTo(@(10));
        }];
    }
    return _userName;
}

- (UIImageView *)vipImage {
    if (!_vipImage) {
        _vipImage = [[UIImageView alloc] init];
        _vipImage.contentMode = UIViewContentModeCenter;
        [self addSubview:_vipImage];
        [_vipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userName);
            make.left.equalTo(self.userName.mas_right).offset(8);
            make.height.equalTo(@(14));
            make.width.equalTo(@(14));
        }];
    }
    return _vipImage;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        [self addSubview:_time];
        _time.font = [UIFont systemFontOfSize:11];
        _time.textColor = [UIColor lightGrayColor];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_userName.mas_leading);
            make.bottom.equalTo(_userImage.mas_bottom);
            make.top.equalTo(_userName.mas_bottom);
        }];
    }
    return _time;
}

- (UILabel *)statues {
    if (!_statues) {
        _statues = [[UILabel alloc] init];
        _statues.numberOfLines = 0;
        _statues.font = [UIFont systemFontOfSize:14];
        _statues.textColor = [UIColor tao_textLableColor];
        [self addSubview:_statues];
        [_statues mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userName.mas_left);
            make.right.equalTo(@(-10));
            make.bottom.equalTo(@(-10));
            make.top.equalTo(self.userImage.mas_bottom).offset(10);
        }];
    }
    return _statues;
}

- (void)setComment:(Taocomment *)comment {
    _comment = comment;
    [self userName];
    [self userImage];
    [self vipImage];
    [self time];
    [self statues];
    

    [self.userImage yy_setImageWithURL:[NSURL URLWithString:comment.user.avatar_hd] placeholder:[UIImage imageNamed:@"avatar_default_small"]];
    self.userImage.clipsToBounds = YES;
    self.userImage.layer.cornerRadius = 20;
    
    comment.user.vip = comment.user.mbtype >2;
    if (comment.user.isVip) {
        self.vipImage.hidden = NO;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", comment.user.mbrank];
        self.vipImage.image = [UIImage imageNamed:vipName];
        
        self.userName.textColor = [UIColor orangeColor];
    } else {
        self.userName.textColor = [UIColor blackColor];
        self.vipImage.hidden = YES;
    }
    
    self.userName.text = comment.user.name;
    self.time.text = [NSString changeTimeWithTimeString:comment.created_at];
    self.statues.attributedText = [[TaoTwitterTextLableRegexKitLiteTool shared]pastAttributedTextWithText:comment.text font:self.statues.font];
}
@end
