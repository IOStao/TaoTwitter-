//
//  TaoRegexKitLiteTool.m
//  TaoTwitter
//
//  Created by wzt on 15/11/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterTextLableRegexKitLiteTool.h"
#import <RegexKitLite/RegexKitLite.h>
#import "TaoNetManager.h"
#import "TaoTwitterTextPart.h"
#import "TaoComposeEmotionPlistTool.h"
#import "TaoComposeEmotionModel.h"

// 表情的规则
static NSString const * emotionPattern = @"\\[[^ \\[\\]]+?\\]";
// @的规则
static NSString const * atPattern = @"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)";
// #话题#的规则
static NSString const * topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";

static NSString const * urlPattern = @"([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>.',;]*)?";

static NSString const * mailPattern = @"/^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$/";

static TaoTwitterTextLableRegexKitLiteTool *_TaoTwitterTextLableRegexKitLiteTool;
@implementation TaoTwitterTextLableRegexKitLiteTool

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _TaoTwitterTextLableRegexKitLiteTool = [[TaoTwitterTextLableRegexKitLiteTool alloc] init];
    });
    return _TaoTwitterTextLableRegexKitLiteTool;
}

- (NSMutableArray *)checkAttributedStringWithText:(NSString *)text {
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@|%@",emotionPattern,mailPattern,topicPattern,urlPattern,atPattern];
    
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return ;
        
        TaoTwitterTextPart *part = [[TaoTwitterTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
       
        
        if ([part.text hasPrefix:@"@"] ){
            NSRange range = NSMakeRange(part.range.location + part.range.length, 1);
            NSString *com;
            if ([text substringFromIndex:range.location].length > 1) {
                com = [text substringWithRange:range];}
            BOOL isCom = NO;
            if (com) {
                isCom = [com isEqualToString:@"."];
            }
            if (!isCom) {
                 part.specialtype = textTypeAt;
            }else {
                part.specialtype = textNormole;
            }
           
        }else if ([part.text hasPrefix:@"#"] && [part.text hasSuffix:@"#"]){
            part.specialtype = textTypeTopic;
        }else if ([part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"]) {
            part.specialtype = textTypeEmotion;
        }else {
            part.specialtype = urlTypeWeb;

            
            //            part.specialtype = [self TypeWithShortUrl:part.text];
        }
        
        [parts addObject:part];
    }];
    
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return ;
        
        TaoTwitterTextPart *part = [[TaoTwitterTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.specialtype = textNormole;
        [parts addObject:part];
    }];
    
    [parts sortUsingComparator:^NSComparisonResult(TaoTwitterTextPart  * obj1, TaoTwitterTextPart  * obj2) {
        if (obj1.range.location > obj2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    return parts;
}


- (NSAttributedString *)attributedTextWithText:(NSString *)text font:(UIFont *)font {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    NSAttributedString *substr = nil;
    
    NSMutableArray *parts = [self checkAttributedStringWithText: text];
    
    for (TaoTwitterTextPart *part in parts) {
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        
        switch (part.specialtype) {
            case  textTypeAt:
            case  textTypeTopic:{
                substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                           NSForegroundColorAttributeName
                                                                                           : [UIColor tao_foregroundColor]
                                                                                           
                                                                                           }];
                
                
            }
                
                break;
                
            case textTypeEmotion: {
                NSString *emotionName = [[TaoComposeEmotionPlistTool standard] emotionWithChs:part.text].png ;
                if (emotionName) {
                    
                    attch.image  = [UIImage imageNamed:emotionName];
                    attch.bounds = CGRectMake(0, -3.5, font.lineHeight, font.lineHeight);
                    substr = [NSAttributedString attributedStringWithAttachment:attch];
                }else {
                    substr = [[NSAttributedString alloc] initWithString:part.text];
                }
            }
                break;
            case urlTypeWeb: {
                attch.image  = [UIImage imageNamed:@"timeline_card_small_web"];
                attch.bounds = CGRectMake(0, -3, 14, 14);
                NSMutableAttributedString *textA = [[NSMutableAttributedString attributedStringWithAttachment:attch]mutableCopy];
                NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"网页链接" attributes:@{
                                                                                                        NSForegroundColorAttributeName
                                                                                                        : [UIColor tao_foregroundColor]
                                                                                                        
                                                                                                        
                                                                                                        }];
                [textA appendAttributedString:a];
                substr = textA;
            }
                break;
            case urlTypeVideo: {
                attch.image  = [UIImage imageNamed:@"timeline_card_small_video"];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                NSMutableAttributedString *textA = (NSMutableAttributedString *)[NSMutableAttributedString attributedStringWithAttachment:attch];
                [textA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, textA.length)];
                NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"网页链接" attributes:@{
                                                                                                        NSForegroundColorAttributeName
                                                                                                        : [UIColor tao_foregroundColor]
                                                                                                        
                                                                                                        }];
                [textA appendAttributedString:a];
                substr = [textA mutableCopy];
            }
                break;
            case urlTypeMusic: {
                attch.image  = [UIImage imageNamed:@"timeline_card_small_web"];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                NSMutableAttributedString *textA = (NSMutableAttributedString *)[NSMutableAttributedString attributedStringWithAttachment:attch];
                [textA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, textA.length)];
                NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"音乐" attributes:@{
                                                                                                      NSForegroundColorAttributeName
                                                                                                      : [UIColor tao_foregroundColor]
                                                                                                      
                                                                                                      }];
                [textA appendAttributedString:a];
                substr = [textA mutableCopy];
            }
                break;
            case urlTypeActivity: {
                attch.image  = [UIImage imageNamed:@"timeline_card_small_web"];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                NSMutableAttributedString *textA = (NSMutableAttributedString *)[NSMutableAttributedString attributedStringWithAttachment:attch];
                [textA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, textA.length)];
                NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"活动" attributes:@{
                                                                                                      NSForegroundColorAttributeName
                                                                                                      : [UIColor tao_foregroundColor]
                                                                                                      
                                                                                                      }];
                [textA appendAttributedString:a];
                substr = [textA mutableCopy];
            }
                break;
            case urlTypeVote: {
                attch.image  = [UIImage imageNamed:@"timeline_card_small_web"];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                NSMutableAttributedString *textA = (NSMutableAttributedString *)[NSMutableAttributedString attributedStringWithAttachment:attch];
                [textA addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, textA.length)];
                NSAttributedString *a = [[NSAttributedString alloc] initWithString:@"投票" attributes:@{
                                                                                                      NSForegroundColorAttributeName
                                                                                                      : [UIColor tao_foregroundColor]
                                                                                                      
                                                                                                      }];
                [textA appendAttributedString:a];
                substr = [textA mutableCopy];
                
            }
            case textNormole: {
                substr = [[[NSAttributedString alloc] initWithString:part.text]mutableCopy];
            }
            default:
                break;
        }
        [attributedText appendAttributedString:substr];
        
    }
    
    
    
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    return [attributedText copy];
}

- (urlType)TypeWithShortUrl:(NSString *)shortUrl {
   __block urlType type;
    [[TaoNetManager sharedInstance]requestWithPath:shortUrl parameters:nil completion:^(NSError *error, Taourls *resultObject) {
        if (error) {
            type = urlTypeWeb;
        }else {
            type = [[resultObject.urls objectAtIndex:0]integerValue];}
    }];
    return type;
}
@end
