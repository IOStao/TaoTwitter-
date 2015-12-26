//
//  TaoStatuesViewLayout.m
//  TaoTwitter
//
//  Created by wzt on 15/12/11.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoStatuesViewLayout.h"
//#import <YYTextLayout.h>
#import "TaoTwitterTextLableRegexKitLiteTool.h"
#import "TaoStatusPhotosView.h"
//#import "NSObject+TaoYYlayout.h"
//#import <NSAttributedString+YYText.h>


@implementation TaoStatuesViewLayout

- (void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    
    self.userImageFrame = CGRectMake(gloableMargin, gloableMargin, userImageHeightAndWidth, userImageHeightAndWidth);
    
    self.userName = twitter.user.name;
    CGSize userSize = [self.userName sizeWithFont:[UIFont systemFontOfSize:userNameFont]];
    self.userNameFrame = CGRectMake(CGRectGetMaxX(self.userImageFrame) + gloableMargin, gloableMargin,userSize.width,userSize.height);
    
    twitter.user.vip = twitter.user.mbtype >2;
    if (twitter.user.isVip) {
        self.vipImageFrame = CGRectMake(CGRectGetMaxX(self.userNameFrame) + lableMargin, gloableMargin, vipImageHeightAndWidth, vipImageHeightAndWidth);
    }else {
        self.vipImageFrame = CGRectZero;
     
    }
    
    self.time = [NSString changeTimeWithTimeString:twitter.created_at];
    CGSize timeSize = [self.time sizeWithFont:[UIFont systemFontOfSize:otherFont]];
    self.timeFrame = CGRectMake(self.userNameFrame.origin.x, CGRectGetMaxY(self.userNameFrame),timeSize.width,timeSize.height);
    
    
    self.device = [self setSource:twitter.source];
    
    CGSize deviceSize = [self.device sizeWithFont:[UIFont systemFontOfSize:otherFont]];
    self.deviceFrame = CGRectMake(CGRectGetMaxX(self.timeFrame) + otherMargin, CGRectGetMaxY(self.userNameFrame),deviceSize.width,deviceSize.height);
    
    
    self.status =  [[TaoTwitterTextLableRegexKitLiteTool shared]attributedTextWithText:twitter.text font:[UIFont systemFontOfSize:statuesFont]];
    CGSize statusSize = [self.status boundingRectWithSize:CGSizeMake(TaoScreenWidth - 2 * gloableMargin, HUGE) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.statuesFrame = CGRectMake(gloableMargin, CGRectGetMaxY(self.userImageFrame) + gloableMargin,statusSize.width,statusSize.height);

    
    
    if (twitter.pic_urls.count) {
        CGRect r = {CGPointMake(gloableMargin,CGRectGetMaxY(self.statuesFrame) + gloableMargin),[TaoStatusPhotosView sizeWithCount:twitter.pic_urls.count]};
        self.photosViewFrame = r;
        self.statuesViewHeight = CGRectGetMaxY(self.photosViewFrame);
    } else {
        self.photosViewFrame = CGRectZero;
        self.statuesViewHeight = CGRectGetMaxY(self.statuesFrame);
    }
}

- (NSString *)setSource:(NSString *)source {
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
