//
//  TaoTwitterLayout.m
//  TaoTwitter
//
//  Created by wzt on 15/12/11.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterLayout.h"
#import "TaoStatuesViewLayout.h"
#import "TaoRStatuesViewLayout.h"
#import "TaoTwitterCellBarLayout.h"

@implementation TaoTwitterLayout

- (void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    
    self.statuesViewLayout = [[TaoStatuesViewLayout alloc] init];
    self.statuesViewLayout.twitter = twitter;
    self.statuesViewFrame = CGRectMake(0, 0, TaoScreenWidth, self.statuesViewLayout.statuesViewHeight);
    
    self.barLayout = [[TaoTwitterCellBarLayout alloc] init];
    
    if (twitter.retweeted_status) {
        self.rStatuesViewLayout = [[TaoRStatuesViewLayout alloc] init];
        self.rStatuesViewLayout.rtwitter = twitter.retweeted_status;
         self.rStatuesViewFrame = CGRectMake(0, CGRectGetMaxY(self.statuesViewFrame) + gloableMargin, TaoScreenWidth, self.rStatuesViewLayout.rStatuesViewHeight);
        
        self.barLayout.twitter = twitter;
        self.toolBarFrame = CGRectMake(0, CGRectGetMaxY(self.rStatuesViewFrame) + gloableMargin, TaoScreenWidth, toolBarHeight);
        self.twitterCellHeight =  CGRectGetMaxY(self.toolBarFrame);
    } else {
        self.barLayout.twitter = twitter;
        self.toolBarFrame = CGRectMake(0, CGRectGetMaxY(self.statuesViewFrame) + gloableMargin, TaoScreenWidth, toolBarHeight);
        
        self.twitterCellHeight = CGRectGetMaxY(self.toolBarFrame);
        self.rStatuesViewFrame = CGRectZero;
    }
    
}
@end
