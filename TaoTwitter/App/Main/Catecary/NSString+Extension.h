//
//  NSString+Extension.h
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
/**
 *  用于时间的转换
 *
 *  @param creatTime 传入的时间字符串
 *
 *  @return 中国格式的时间字符串
 */
+ (NSString *)changeTimeWithTimeString:(NSString *)creatTime;

/**
 *  emoji
 */
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(NSInteger)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;

@end
