//
//  TaoAccountTableViewCell.m
//  TaoTwitter
//
//  Created by wzt on 15/10/24.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAccountTableViewCell.h"
#import <YYWebImage/YYWebImage.h>

@interface TaoAccountTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *accountImage;
@property (weak, nonatomic) IBOutlet UILabel *accountName;

@end

@implementation TaoAccountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setAccount:(TaoAccountItem *)account {
    _account = account;

    [_accountImage yy_setImageWithURL:[NSURL URLWithString:_account.user.avatar_hd] placeholder:[UIImage imageNamed:@"login_user"]];
    self.accountImage.layer.cornerRadius = self.accountImage.frame.size.width / 2;
    self.accountImage.clipsToBounds = YES;
    _accountName.text = _account.user.screen_name;
}


@end
