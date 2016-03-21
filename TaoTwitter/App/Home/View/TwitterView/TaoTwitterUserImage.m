//
//  TaoTwitterUserImage.m
//  TaoTwitter
//
//  Created by wzt on 15/12/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterUserImage.h"
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>

@interface TaoTwitterUserImage ()
@property (nonatomic, weak) UIImageView *userimageView;
@property (nonatomic, weak) UIImageView *verifiedView;

@end

@implementation TaoTwitterUserImage

- (UIImageView *)verifiedView {
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
        [verifiedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(14));
            make.bottom.right.equalTo(@(0));
        }];
    }
    return _verifiedView;
}

- (UIImageView *)userimageView {
    if (!_userimageView) {
        UIImageView *userimageView = [[UIImageView alloc] init];
        [self addSubview:userimageView];
        self.userimageView = userimageView;
        [userimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(@(0));
        }];
    }
    return _userimageView;
}

- (void)setUser:(Taousers *)user {
    _user = user;
    
    // 1.下载图片
    
    [self.userimageView yy_setImageWithURL:[NSURL URLWithString:user.avatar_hd] placeholder:[UIImage imageNamed:@"avatar_default_small"]];
    self.userimageView.clipsToBounds = YES;
    self.userimageView.layer.cornerRadius = 20;
    self.userimageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.userimageView.layer.borderWidth = 0.5;
    
    
    // 2.设置加V图片
    switch (user.verified_type) {
        case TaoUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case TaoUserVerifiedOrgEnterprice:
        case TaoUserVerifiedOrgMedia:
        case TaoUserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case TaoUserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }

}


@end
