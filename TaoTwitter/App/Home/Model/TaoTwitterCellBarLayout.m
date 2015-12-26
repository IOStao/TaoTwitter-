//
//  TaoTwitterCellBarLayout.m
//  TaoTwitter
//
//  Created by wzt on 15/12/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterCellBarLayout.h"

@implementation TaoTwitterCellBarLayout

-(void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    self.rCcount = [self setupBtnTitleWithCount:twitter.reposts_count defaultTitle:@"转发"];
    self.CCcount = [self setupBtnTitleWithCount:twitter.comments_count defaultTitle:@"评论"];
    self.lCcount = [self setupBtnTitleWithCount:twitter.attitudes_count defaultTitle:@"赞"];
}

- (NSString *)setupBtnTitleWithCount:(int)count defaultTitle:(NSString *)defaultTitle {
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%d", count];
    }
    return defaultTitle;
}

@end
