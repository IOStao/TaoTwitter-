
//  TaoTwitterStatusView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/2.
//  Copyright © 2015年 Baidu. All rights reserved.


#import "TaoTwitterStatusView.h"
#import "TaoStatusPhotosView.h"
#import "TaoTwitterTextLable.h"
#import "TaoTwitterUserImage.h"
#import "TaoStatuesViewLayout.h"


@interface TaoTwitterStatusView ()
@property (strong, nonatomic)  TaoTwitterUserImage *userImage;
@property (strong, nonatomic)  TaoTwitterTextLable *userName;
@property (strong, nonatomic)  UIImageView *vipImage;
@property (strong, nonatomic)  TaoTwitterTextLable *time;
@property (strong, nonatomic)  TaoTwitterTextLable *device;
@property (strong, nonatomic)  TaoTwitterTextLable *statues;
@property (strong, nonatomic)  TaoStatusPhotosView *photosView;

@end

@implementation TaoTwitterStatusView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configerSubviews];
    }
    return self;
}

- (void)configerSubviews {
    self.userImage = [[TaoTwitterUserImage alloc]init];
    [self addSubview:self.userImage];
    
    
    self.userName = [[TaoTwitterTextLable alloc] init];
    [self addSubview:self.userName];
   
    
    self.vipImage = [[UIImageView alloc] init];
    self.vipImage.contentMode = UIViewContentModeCenter;
    [self addSubview:self.vipImage];
    
    
    self.time = [[TaoTwitterTextLable alloc] init];
    [self addSubview:self.time];
    

    self.device = [[TaoTwitterTextLable alloc] init];
    [self addSubview:self.device];

    
   
    self.statues = [[TaoTwitterTextLable alloc] init];
    [self addSubview:_statues];
    
    self.photosView = [[TaoStatusPhotosView alloc]init];
    [self addSubview:_photosView];
    
}

- (void)setStatuesViewLayout:(TaoStatuesViewLayout *)statuesViewLayout {
   _statuesViewLayout = statuesViewLayout;
    
    self.userImage.user = statuesViewLayout.twitter.user;
    self.userImage.frame = statuesViewLayout.userImageFrame;
    
    self.userName.frame = statuesViewLayout.userNameFrame;
    self.userName.textLayout = statuesViewLayout.userNameLayout;

  
    if (!CGRectEqualToRect(statuesViewLayout.vipImageFrame, CGRectZero)) {
        self.vipImage.hidden = NO;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", statuesViewLayout.twitter.user.mbrank];
        self.vipImage.image = [UIImage imageNamed:vipName];
        self.vipImage.frame = statuesViewLayout.vipImageFrame;
    } else {
        self.vipImage.hidden = YES;
    }

    self.time.frame = statuesViewLayout.timeFrame;
    self.time.textLayout = statuesViewLayout.timeLayout;
     self.time.bottom = self.userImage.bottom;
    

    
    self.device.frame = statuesViewLayout.deviceFrame;
    self.device.textLayout = statuesViewLayout.deviceLayout;
    self.device.bottom =self.time.bottom;
    

    self.statues.frame = statuesViewLayout.statuesFrame;
    self.statues.textLayout = statuesViewLayout.statuesLayout;
    

    
    if (!CGRectEqualToRect(statuesViewLayout.photosViewFrame, CGRectZero)) {
        self.photosView.hidden = NO;
        self.photosView.pictureLayout = statuesViewLayout.pictureLayout;
    } else {
        self.photosView.hidden = YES;
    }
    self.photosView.frame = statuesViewLayout.photosViewFrame;
}

@end

//约束
//#import "TaoTwitterStatusView.h"
//#import "TaoStatusPhotosView.h"
//#import <Masonry.h>
//#import "TaoTwitterTextLable.h"
//#import "TaoTwitterUserImage.h"
//
//
//@interface TaoTwitterStatusView ()
//@property (strong, nonatomic)  TaoTwitterUserImage *userImage;
//@property (strong, nonatomic)  UILabel *userName;
//@property (strong, nonatomic)  UIImageView *vipImage;
//@property (strong, nonatomic)  UILabel *time;
//@property (strong, nonatomic)  UILabel *device;
//@property (strong, nonatomic)  TaoTwitterTextLable *statues;
//@property (strong, nonatomic)  TaoStatusPhotosView *photosView;
//
//@end
//
//@implementation TaoTwitterStatusView
//- (TaoTwitterUserImage *)userImage {
//    if (!_userImage) {
//       self.userImage = [[TaoTwitterUserImage alloc]init];
//        [self addSubview:_userImage];
//        [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(40));
//            make.width.equalTo(@(40));
//            make.left.equalTo(@(10));
//            make.top.equalTo(@(10));
//        }];
//    }
//    return _userImage;
//}
//
//- (UILabel *)userName {
//    if (!_userName ) {
//       self.userName = [[UILabel alloc] init];
//       self.userName.font = [UIFont systemFontOfSize:15];
//        [self addSubview:_userName];
//        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.userImage.mas_right).offset(8);
//            make.top.equalTo(@(10));
//        }];
//    }
//    return _userName;
//}
//
//- (UIImageView *)vipImage {
//    if (!_vipImage) {
//       self.vipImage = [[UIImageView alloc] init];
//       self.vipImage.contentMode = UIViewContentModeCenter;
//        [self addSubview:_vipImage];
//        [_vipImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.userName);
//            make.left.equalTo(self.userName.mas_right).offset(8);
//            make.height.equalTo(@(14));
//            make.width.equalTo(@(14));
//        }];
//    }
//    return _vipImage;
//}
//
//- (UILabel *)time {
//    if (!_time) {
//       self.time = [[UILabel alloc] init];
//        [self addSubview:_time];
//       self.time.font = [UIFont systemFontOfSize:11];
//       self.time.textColor = [UIColor lightGrayColor];
//        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(_userName.mas_leading);
//            make.bottom.equalTo(_userImage.mas_bottom);
//            make.top.equalTo(_userName.mas_bottom);
//        }];
//    }
//    return _time;
//}
//
//- (UILabel *)device {
//    if (!_device) {
//       self.device = [[UILabel alloc] init];
//        [self addSubview:_device];
//       self.device.font = [UIFont systemFontOfSize:11];
//       self.device.textColor = [UIColor lightGrayColor];
//        [_device mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_time.mas_right).offset(15);
//            make.bottom.equalTo(_time.mas_bottom);
//            make.top.equalTo(_time.mas_top);
//        }];
//    }
//    return _device;
//}
//
//- (TaoTwitterTextLable *)statues {
//    if (!_statues) {
//       self.statues = [[TaoTwitterTextLable alloc] init];
//       self.statues.numberOfLines = 0;
//       self.statues.font = [UIFont systemFontOfSize:16];
//       self.statues.textColor = [UIColor tao_textLableColor];
//        [self addSubview:_statues];
//        [_statues mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(10));
//            make.right.equalTo(@(-10));
//            make.top.equalTo(self.userImage.mas_bottom).offset(10);
//        }];
//    }
//    return _statues;
//}
//
//- (TaoStatusPhotosView *)photosView {
//    if (!_photosView) {
//       self.photosView = [[TaoStatusPhotosView alloc]init];
//        [self addSubview:_photosView];
//    }
//    return _photosView;
//}
//
//
//- (void)setTwitter:(Taostatus *)twitter {
//    _twitter = twitter;
//    self.userImage.user = twitter.user;
//    
//    twitter.user.vip = twitter.user.mbtype >2;
//    if (twitter.user.isVip) {
//        self.vipImage.hidden = NO;
//        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", twitter.user.mbrank];
//        self.vipImage.image = [UIImage imageNamed:vipName];
//        
//        self.userName.textColor = [UIColor orangeColor];
//    } else {
//        self.userName.textColor = [UIColor blackColor];
//        self.vipImage.hidden = YES;
//    }
//    
//    self.userName.text = twitter.user.name;
//    self.time.text = [NSString changeTimeWithTimeString:twitter.created_at];
//    self.device.text = [self setSource:twitter.source];
//    
//    self.statues.attributedText = [self.statues attributedTextWithText:twitter.text];
//    
//    if (twitter.pic_urls.count) {
//        self.photosView.photos = twitter.pic_urls;
//        self.photosView.hidden = NO;
//        CGSize size = [TaoStatusPhotosView sizeWithCount:twitter.pic_urls.count];
//        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(10));
//            make.top.equalTo(self.statues.mas_bottom).offset(10);
//            make.bottom.equalTo(@(0));
//            make.height.equalTo(@(size.height)).priorityHigh();
//            make.width.equalTo(@(size.width));
//        }];
//    } else {
//        self.photosView.hidden = YES;
//        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(10));
//            make.bottom.equalTo(@(0));
//            make.top.equalTo(self.statues.mas_bottom).offset(0);
//        }];
//    }
//
//}
//
//- (NSString *)setSource:(NSString *)source
//{
//    // 正则表达式 NSRegularExpression
//    // 截串 NSString
//    if (source.length) {
//        NSRange range;
//        range.location = [source rangeOfString:@">"].location + 1;
//        range.length = [source rangeOfString:@"</"].location - range.location;
//        return [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
//    } else {
//        return  @"www.weibo.com";
//    }
//}


//@end
