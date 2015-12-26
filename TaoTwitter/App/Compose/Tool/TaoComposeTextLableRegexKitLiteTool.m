//
//  TaoComposeTextLableRegexKitLiteTool.m
//  TaoTwitter
//
//  Created by wzt on 15/12/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeTextLableRegexKitLiteTool.h"
#import "TaoComposeTextPart.h"
#import <RegexKitLite/RegexKitLite.h>
#import "TaoComposeEmotionPlistTool.h"
#import "TaoComposeEmotionModel.h"
#import "NSTextAttachment+TaoTextAttachment.h"
// 表情的规则
static NSString const * emotionPattern = @"\\[[^ \\[\\]]+?\\]";
// @的规则
static NSString const * atPattern = @"@([\\x{4e00}-\\x{9fa5}A-Za-z0-9_\\-]+)";
// #话题#的规则
static NSString const * topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";

static TaoComposeTextLableRegexKitLiteTool *_TaoComposeTextLableRegexKitLiteTool;

@implementation TaoComposeTextLableRegexKitLiteTool

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _TaoComposeTextLableRegexKitLiteTool = [[TaoComposeTextLableRegexKitLiteTool alloc] init];
    });
    return _TaoComposeTextLableRegexKitLiteTool;
}


- (NSMutableArray *)checkAttributedStringWithText:(NSString *)text {
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@",emotionPattern,topicPattern,atPattern];
    
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return ;
        
        TaoComposeTextPart *part = [[TaoComposeTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        
        if ([part.text hasPrefix:@"@"]){
            part.specialtype = textTypeAt;
#warning noti
        }else if ([part.text hasPrefix:@"#"] && [part.text hasSuffix:@"#"]){
            part.specialtype = textTypeTopic;
        }else if ([part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"]) {
            part.specialtype = textTypeEmotion;
        }
        [parts addObject:part];
    }];
    
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return ;
        
        TaoComposeTextPart *part = [[TaoComposeTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.specialtype = textNormole;
        [parts addObject:part];
    }];
    
    [parts sortUsingComparator:^NSComparisonResult(TaoComposeTextPart  * obj1, TaoComposeTextPart  * obj2) {
        if (obj1.range.location > obj2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    return parts;
}

- (NSAttributedString *)attributedTextWithText:(NSString *)text attributedText:(NSAttributedString *)attributedText font:(UIFont *)font{
    
    NSMutableAttributedString *newAttributedText = [[NSMutableAttributedString alloc] init];
    [newAttributedText appendAttributedString:attributedText];
    NSAttributedString *substr = nil;
    NSMutableArray *parts = [self checkAttributedStringWithText: text];
   
    
    for (TaoComposeTextPart *part in parts) {
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
                    attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                    attch.imageDescribtion = part.text;
                    substr = [NSAttributedString attributedStringWithAttachment:attch];
                }else {
                    substr = [[NSAttributedString alloc] initWithString:part.text];
                }
            }
                break;
            case textNormole: {
                if ([part.text containsString:@"#"]) {
                
                    NSLog(@"%@",part);
                    NSLog(@"sakldfhlsd");
                }
                [newAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:part.range];
            }
            default:
                break;
        }
        if (substr && part.specialtype != textNormole) {
            [newAttributedText replaceCharactersInRange:part.range withAttributedString:substr];
        }
        
    }
    
     [newAttributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, newAttributedText.length)];
    return [newAttributedText copy];
}
@end
