//
//  UIPasteboard+AttributedSring.m
//  TaoTwitter
//
//  Created by wzt on 15/12/24.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "UIPasteboard+AttributedSring.h"
#import "NSTextAttachment+TaoTextAttachment.h"

@implementation UIPasteboard (AttributedSring)
- (void)setAttributString:(NSAttributedString *)attributString {
    __block NSMutableString *pastString = [[NSMutableString alloc] init];
    
    [attributString enumerateAttributesInRange:NSMakeRange(0, attributString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *attch = attrs[NSAttachmentAttributeName];
        if (attch && attch.imageDescribtion) {
            [pastString appendString:attch.imageDescribtion];
        }else {
            NSAttributedString *sub = [attributString attributedSubstringFromRange:range];
            [pastString appendString:sub.string];
        }
    }];
    [self setString:[pastString copy]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:attributString];
    NSDictionary *item = @{@"TextAttachmentAttributeName":data};
    [self addItems:@[item]];
    
    
}

- (NSAttributedString *)attributString {
    for (NSDictionary *item in self.items) {
        NSData *data = item[@"TextAttachmentAttributeName"];
        if (data) return [NSKeyedUnarchiver unarchiveObjectWithData:data];

    }
    return nil;
    
}

- (NSString *)mateTextFromAttributString:(NSAttributedString *)attributString {
    __block NSMutableString *pastString = [[NSMutableString alloc] init];
    
    [attributString enumerateAttributesInRange:NSMakeRange(0, attributString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *attch = attrs[NSAttachmentAttributeName];
        if (attch && attch.imageDescribtion) {
            [pastString appendString:attch.imageDescribtion];
        }else {
            NSAttributedString *sub = [attributString attributedSubstringFromRange:range];
            [pastString appendString:sub.string];
        }
    }];
    return [pastString copy];
}
@end
