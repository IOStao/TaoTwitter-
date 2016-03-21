//
//  TaoTwitterTextLable.m
//  TaoTwitter
//
//  Created by wzt on 15/11/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterTextLable.h"



@implementation TaoTwitterTextLable

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ignoreCommonProperties = YES;
        self.displaysAsynchronously = YES;
        self.fadeOnAsynchronouslyDisplay = NO;
        self.fadeOnHighlight = NO;
    }
    return self;
}


@end


