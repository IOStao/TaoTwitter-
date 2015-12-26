//
//  TaoComposeEmotionModel.m
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeEmotionModel.h"
#import <MJExtension/NSObject+MJCoding.h>

@implementation TaoComposeEmotionModel
#warning 等待优化
MJCodingImplementation

- (BOOL)isEqual:(TaoComposeEmotionModel *)other {
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}
@end
