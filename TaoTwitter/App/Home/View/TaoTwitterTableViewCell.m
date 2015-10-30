//
//  TaoTwitterTableViewCell.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//
#import "TaoStatusPhotosView.h"
#import "TaoTwitterTableViewCell.h"
#import <Masonry/Masonry.h>
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>


@interface TaoTwitterTableViewCell ()
@property (nonatomic, strong)  UIView *statusView;
@property (strong, nonatomic)  UIImageView *userImage;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic)  UIImageView *vipImage;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *device;
@property (strong, nonatomic)  UILabel *statues;
@property (strong, nonatomic)  TaoStatusPhotosView *photosView;
@property (strong, nonatomic)  UILabel *rStatues;
@property (strong, nonatomic)  TaoStatusPhotosView *rphotosView;
@property (nonatomic, strong)  UIView *rStatusView;
@property (nonatomic, strong)  UIView *line;
@property (nonatomic, strong)  UIView *leftLine;
@end

@implementation TaoTwitterTableViewCell

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc]init];
        [self.contentView addSubview:_statusView];
        [_statusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@(0));
        }];
    }
    return _statusView;
}

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = [[UIImageView alloc]init];
    
        [_statusView addSubview:_userImage];
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
        [_statusView addSubview:_userName];
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
        [_statusView addSubview:_vipImage];
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
        [_statusView addSubview:_time];
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

- (UILabel *)device {
    if (!_device) {
        _device = [[UILabel alloc] init];
        [_statusView addSubview:_device];
        _device.font = [UIFont systemFontOfSize:11];
        _device.textColor = [UIColor lightGrayColor];
        [_device mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_time.mas_right).offset(15);
            make.bottom.equalTo(_time.mas_bottom);
            make.top.equalTo(_time.mas_top);
        }];
    }
    return _device;
}

- (UILabel *)statues {
    if (!_statues) {
        _statues = [[UILabel alloc] init];
        _statues.numberOfLines = 0;
        _statues.font = [UIFont systemFontOfSize:16];
        _statues.textColor = [UIColor tao_textLableColor];
        [self.statusView addSubview:_statues];
        [_statues mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.right.equalTo(@(-10));
            make.top.equalTo(self.userImage.mas_bottom).offset(10);
        }];
    }
    return _statues;
}

- (TaoStatusPhotosView *)photosView {
    if (!_photosView) {
        _photosView = [[TaoStatusPhotosView alloc]init];
        [self.statusView addSubview:_photosView];
    }
    return _photosView;
}

- (UIView *)rStatusView {
    if (!_rStatusView) {
        _rStatusView = [[UIView alloc] init];
        [self.contentView addSubview:_rStatusView];
    }
    return _rStatusView;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine  = [[UIView alloc] init];
        _leftLine.backgroundColor = [UIColor lightGrayColor];
        [self.rStatusView addSubview:_leftLine];
        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.width.equalTo(@(10));
            make.top.equalTo(self.rStatues.mas_top);
            make.bottom.equalTo(self.rStatues.mas_bottom);
        }];
    }
    return _leftLine;
}

- (UILabel *)rStatues {
    if (!_rStatues) {
        _rStatues = [[UILabel alloc] init];
        _rStatues.numberOfLines = 0;
        _rStatues.font = [UIFont systemFontOfSize:16];
        _rStatues.textColor = [UIColor tao_textLableColor];
        [self.rStatusView addSubview:_rStatues];
        [_rStatues mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(self.leftLine.mas_right).offset(5);
            make.right.equalTo(@(-10));
        }];
    }
    return _rStatues;
}

- (TaoStatusPhotosView *)rphotosView {
    if (!_rphotosView) {
        _rphotosView = [[TaoStatusPhotosView alloc] init];
        [self.rStatusView addSubview:_rphotosView];
    }
    return _rphotosView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.right.bottom.equalTo(@(0));
            make.height.equalTo(@(0.5));
            make.top.equalTo(self.rStatusView.mas_bottom).offset(15);
        }];
        
    }
    return _line;
}

- (void)setTwtitter:(TaoTwitter *)twtitter {
    _twtitter = twtitter;
    [self statusView];
    [self rStatues];
    [self line];
    [self leftLine];
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:twtitter.user.avatar_hd] placeholderImage:[UIImage imageNamed:@"avatar_default_small"] options:SDWebImageLowPriority];
    self.userImage.clipsToBounds = YES;
    self.userImage.layer.cornerRadius = 20;
    
    if (twtitter.user.isVip) {
        self.vipImage.hidden = NO;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", twtitter.user.mbrank];
        self.vipImage.image = [UIImage imageNamed:vipName];
        
        self.userName.textColor = [UIColor orangeColor];
    } else {
        self.userName.textColor = [UIColor blackColor];
        self.vipImage.hidden = YES;
    }

    self.userName.text = twtitter.user.name;
    self.time.text = [NSString changeTimeWithTimeString:twtitter.created_at];
    self.device.text = [self setSource:twtitter.source];
    self.statues.text = twtitter.text;
    
    if (twtitter.pic_urls.count) {
        self.photosView.photos = twtitter.pic_urls;
         self.photosView.hidden = NO;
        CGSize size = [TaoStatusPhotosView sizeWithCount:_twtitter.pic_urls.count];
        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.top.equalTo(self.statues.mas_bottom).offset(10);
            make.bottom.equalTo(@(0));
            make.height.equalTo(@(size.height)).priorityHigh();
            make.width.equalTo(@(size.width));
        }];
    } else {
        self.photosView.hidden = YES;
        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(10));
            make.bottom.equalTo(@(0));
            make.top.equalTo(self.statues.mas_bottom).offset(0);
        }];
    }

    if (twtitter.retweeted_status) {
        self.rStatusView.hidden = NO;
//        self.rStatues.hidden = NO;
        [_rStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusView.mas_bottom).offset(10);
            make.left.right.equalTo(@(0));

        }];
        
        TaoTwitter *rt = twtitter.retweeted_status;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", rt.user.name, rt.text];
        self.rStatues.text = retweetContent;
        
        if (twtitter.retweeted_status.pic_urls.count) {
            self.rphotosView.hidden = NO;
            self.rphotosView.photos = twtitter.retweeted_status.pic_urls;
            CGSize size = [TaoStatusPhotosView sizeWithCount:twtitter.retweeted_status.pic_urls.count];
            [self.rphotosView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(10));
                make.top.equalTo(self.rStatues.mas_bottom).offset(10).priorityHigh();
                make.bottom.equalTo(@(0));
                make.height.equalTo(@(size.height)).priorityHigh();
                make.width.equalTo(@(size.width));
            }];
        } else {
            self.rphotosView.hidden = YES;
            [self.rphotosView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(10));
                make.bottom.equalTo(@(0));
                make.top.equalTo(self.rStatues.mas_bottom).offset(0);
                make.height.equalTo(@(0)).priorityHigh();
            }];
        }
    } else {
        self.rStatusView.hidden = YES;
        [_rStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
            make.top.equalTo(self.statusView.mas_bottom).offset(0);
        }];
    }
}

- (NSString *)setSource:(NSString *)source
{
    // 正则表达式 NSRegularExpression
    // 截串 NSString
    if (source.length) {
        NSRange range;
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"</"].location - range.location;
         return [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    } else {
        return  @"www.weibo.com";
    }
}
@end
