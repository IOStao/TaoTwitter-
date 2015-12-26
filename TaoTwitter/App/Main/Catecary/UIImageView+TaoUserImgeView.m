//
//  UIImageView+TaoUserImgeView.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "UIImageView+TaoUserImgeView.h"


@implementation UIImageView (TaoUserImgeView)

+ (UIImageView *)userimageWithTarget:(id)target action:(SEL)action{
    UIImageView *image = [[UIImageView alloc]init];
    image.size = CGSizeMake(30, 30);
    
    [image sd_setImageWithURL:[NSURL URLWithString:[[TaoLoginManager standardUserDefaults] currentUserEntity].user.avatar_hd] placeholderImage:[UIImage imageNamed:@"login_user_highlighted"] options:SDWebImageRetryFailed ];
    image.layer.cornerRadius = image.frame.size.width / 2;
    image.clipsToBounds = YES;
    [image addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target action:action]];
   
    return image;
}
@end
