//
//  TaoComposeEmotionPlistTool.h
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaoComposeEmotionModel;
@interface TaoComposeEmotionPlistTool : NSObject

+ (instancetype)standard;
- (void)addRecentEmotion:(TaoComposeEmotionModel *)emotion;
- (NSArray *)recentEmotions;
- (NSArray *)defaultEmotions;
- (NSArray *)lxhEmotions;
- (NSArray *)emojiEmotions;

/**
 *  通过表情描述找到对应的表情
 *
 *  @param chs 表情描述
 */
- (TaoComposeEmotionModel *)emotionWithChs:(NSString *)chs;


@end
