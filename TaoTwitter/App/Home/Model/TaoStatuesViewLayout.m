//
//  TaoStatuesViewLayout.m
//  TaoTwitter
//
//  Created by wzt on 15/12/11.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoStatuesViewLayout.h"
#import <YYTextLayout.h>
#import "TaoTwitterTextLableRegexKitLiteTool.h"
#import "TaoStatusPhotosView.h"
#import "TaoTwitterPicturesLayout.h"
#import <NSAttributedString+YYText.h>
#import "TaoTwitterPicturesLayout.h"


@implementation TaoStatuesViewLayout

- (void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    
    self.userImageFrame = CGRectMake(gloableMargin, gloableMargin, userImageHeightAndWidth, userImageHeightAndWidth);
    
    YYTextContainer *userContainer = [YYTextContainer containerWithSize:CGSizeMake(HUGE, HUGE)];
    NSMutableAttributedString *userSt = [[NSMutableAttributedString alloc] initWithString:twitter.user.name];
    userSt.yy_font = [UIFont systemFontOfSize:userNameFont];
    userSt.yy_color = twitter.user.mbrank >2 ?[UIColor orangeColor] :[UIColor nb_colorWithHex:0x333333];
    self.userNameLayout = [YYTextLayout layoutWithContainer:userContainer text:userSt];
    self.userNameFrame = CGRectMake(CGRectGetMaxX(self.userImageFrame) + gloableMargin, gloableMargin,self.userNameLayout.textBoundingSize.width,self.userNameLayout.textBoundingSize.height);
    
    twitter.user.vip = twitter.user.mbtype >2;
    if (twitter.user.isVip) {
        self.vipImageFrame = CGRectMake(CGRectGetMaxX(self.userNameFrame) + lableMargin, gloableMargin, vipImageHeightAndWidth, vipImageHeightAndWidth);
    }else {
        self.vipImageFrame = CGRectZero;
     
    }
    
    YYTextContainer *timeContainer = [YYTextContainer containerWithSize:CGSizeMake(HUGE, HUGE)];
    NSMutableAttributedString *timeSt = [[NSMutableAttributedString alloc] initWithString:[NSString changeTimeWithTimeString:twitter.created_at]];
    timeSt.yy_font = [UIFont systemFontOfSize:otherFont];
    timeSt.yy_color = [UIColor nb_colorWithHex:0x828282];
    self.timeLayout = [YYTextLayout layoutWithContainer:timeContainer text:timeSt];
    self.timeFrame = CGRectMake(self.userNameFrame.origin.x, CGRectGetMaxY(self.userNameFrame),self.timeLayout.textBoundingSize.width,self.timeLayout.textBoundingSize.height);
    
    YYTextContainer *deviceContainer = [YYTextContainer containerWithSize:CGSizeMake(HUGE, HUGE)];
    NSMutableAttributedString *deviceSt = [[NSMutableAttributedString alloc] initWithString:[self setSource:twitter.source]];
    deviceSt.yy_font = [UIFont systemFontOfSize:otherFont];
    deviceSt.yy_color = [UIColor nb_colorWithHex:0x828282];
    self.deviceLayout = [YYTextLayout layoutWithContainer:deviceContainer text:deviceSt];
    self.deviceFrame = CGRectMake(CGRectGetMaxX(self.timeFrame) + otherMargin, CGRectGetMaxY(self.userNameFrame),self.deviceLayout.textBoundingSize.width,self.deviceLayout.textBoundingSize.height);
    
    
    YYTextContainer *statuesContainer = [YYTextContainer containerWithSize:CGSizeMake(TaoScreenWidth - 2 * gloableMargin, HUGE)];
    self.statuesLayout = [YYTextLayout layoutWithContainer:statuesContainer text:[[TaoTwitterTextLableRegexKitLiteTool shared]attributedTextWithText:twitter.text font:[UIFont systemFontOfSize:statuesFont]]];
    
    self.statuesFrame = CGRectMake(gloableMargin, CGRectGetMaxY(self.userImageFrame) + gloableMargin,self.statuesLayout.textBoundingSize.width,self.statuesLayout.textBoundingSize.height);

   
    if (twitter.pic_urls.count) {
        self.pictureLayout = [[TaoTwitterPicturesLayout alloc]init];
        self.pictureLayout.twitter = twitter;
        CGRect r = {CGPointMake(gloableMargin,CGRectGetMaxY(self.statuesFrame) + gloableMargin),self.pictureLayout.pictureSize};
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
