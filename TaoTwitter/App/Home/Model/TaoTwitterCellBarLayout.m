//
//  TaoTwitterCellBarLayout.m
//  TaoTwitter
//
//  Created by wzt on 15/12/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterCellBarLayout.h"
#import <YYText/YYText.h>

@implementation TaoTwitterCellBarLayout

-(void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    UIFont *font = [UIFont systemFontOfSize:14];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(TaoScreenWidth, toolBarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *repostText = [[NSMutableAttributedString alloc] initWithString:twitter.reposts_count <= 0 ? @"转发" : [self setupBtnTitleWithCount:twitter.reposts_count]];
    repostText.yy_font = font;
    repostText.yy_color = [UIColor nb_colorWithHex:0x929292];
    _toolbarRepostTextLayout = [YYTextLayout layoutWithContainer:container text:repostText];
    _toolbarRepostTextWidth = _toolbarRepostTextLayout.textBoundingRect.size.width;
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:twitter.comments_count <= 0 ? @"评论" : [self setupBtnTitleWithCount:twitter.comments_count]];
    commentText.yy_font = font;
    commentText.yy_color = [UIColor nb_colorWithHex:0x929292];
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = _toolbarCommentTextLayout.textBoundingRect.size.width;
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:twitter.attitudes_count <= 0 ? @"赞" : [self setupBtnTitleWithCount:twitter.attitudes_count]];
    likeText.yy_font = font;
    likeText.yy_color = [UIColor nb_colorWithHex:0x929292];
    _toolbarLikeTextLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    _toolbarLikeTextWidth = _toolbarLikeTextLayout.textBoundingRect.size.width;
}

- (NSString *)setupBtnTitleWithCount:(int)count {
    NSString *defaultTitle = nil;
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
