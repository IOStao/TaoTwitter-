//
//  TaoComposeTextView.m
//  TaoTwitter
//
//  Created by wzt on 15/12/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeTextView.h"
#import "TaoComposeEmotionModel.h"
#import "UITextView+TaoTextView.h"
#import "UIPasteboard+AttributedSring.h"
#import "TaoTwitterTextLableRegexKitLiteTool.h"




@interface TaoComposeTextView ()


@end

@implementation TaoComposeTextView
- (void)insertEmtion:(NSNotification *)dic {
    TaoComposeEmotionModel *emotion = dic.userInfo[TaoSelectEmotionKey];
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    }else if (emotion.chs) {
        [self insertText:emotion.chs];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (self.selectedRange.length == 0) {
        if (action == @selector(select:) ||
            action == @selector(selectAll:)) {
            return self.text.length||self.attributedText > 0;
        }
        if (action == @selector(paste:)) {
            return [UIPasteboard generalPasteboard].string.length > 0;
        }
    } else {
        if (action == @selector(cut:)) {
            return self.isFirstResponder && self.editable;
        }
        if (action == @selector(copy:)) {
            return YES;
        }
        if (action == @selector(selectAll:)) {
            return self.text.length||self.attributedText > 0;
        }
        if (action == @selector(paste:)) {
            return self.isFirstResponder && self.editable && ([UIPasteboard generalPasteboard].string.length >0);
        }
    }
    return NO;
    
}

- (void)copy:(id)sender {
    UIPasteboard *p = [UIPasteboard generalPasteboard];
    [p setString:[p mateTextFromAttributString:[self.attributedText attributedSubstringFromRange:self.selectedRange]]];
}

- (void)paste:(id)sender {
    UIPasteboard *p = [UIPasteboard generalPasteboard];
    
    if (p.string) {
        NSAttributedString *att = [[TaoTwitterTextLableRegexKitLiteTool shared]pastAttributedTextWithText:p.string font:self.font];
        [self pasteAttributedText:att settingBlock:^(NSMutableAttributedString *attributedText) {
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
    
    
}




//可以实现表情 但是没有和其他APP复制粘贴的功能

//- (void)insertEmtion:(NSNotification *)dic {
//    TaoComposeEmotionModel *emotion = dic.userInfo[TaoSelectEmotionKey];
//    if (emotion.code) {
//        [self insertText:emotion.code.emoji];
//    }else if (emotion.png) {
//        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//        attch.image = [UIImage imageNamed:emotion.png];
//        attch.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
//        attch.imageDescribtion = emotion.chs;
//        NSAttributedString *imageS = [NSAttributedString attributedStringWithAttachment:attch];
//        
//        [self insertAttributedText:imageS settingBlock:^(NSMutableAttributedString *attributedText) {
//            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
//        }];
//    }
//}
//
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    
//    if (self.selectedRange.length == 0) {
//        if (action == @selector(select:) ||
//            action == @selector(selectAll:)) {
//            return self.text.length||self.attributedText > 0;
//        }
//        if (action == @selector(paste:)) {
//            return [UIPasteboard generalPasteboard].string.length > 0 || [UIPasteboard generalPasteboard].attributString.length>0;
//        }
//    } else {
//        if (action == @selector(cut:)) {
//            return self.isFirstResponder && self.editable;
//        }
//        if (action == @selector(copy:)) {
//            return YES;
//        }
//        if (action == @selector(selectAll:)) {
//            return self.text.length||self.attributedText > 0;
//        }
//        if (action == @selector(paste:)) {
//            return self.isFirstResponder && self.editable && ([UIPasteboard generalPasteboard].string.length >0 || [UIPasteboard generalPasteboard].attributString.length >0);
//        }
//    }
//    return NO;
//
//}
//
//- (void)copy:(id)sender {
//    UIPasteboard *p = [UIPasteboard generalPasteboard];
//    [p setAttributString:[self.attributedText attributedSubstringFromRange:self.selectedRange]];
//    NSLog(@"%@",p.string);
//    
//}
//
//- (void)paste:(id)sender {
//    UIPasteboard *p = [UIPasteboard generalPasteboard];
//    if (p.string && !p.attributString) {
//        [self replaceRange:self.selectedTextRange withText:p.string];
//    }
//    if (p.attributString) {
//        NSAttributedString *ps = p.attributString;
//        __weak typeof(ps)psw = ps;
//        __block NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] init];
//        [ps enumerateAttributesInRange:NSMakeRange(0, ps.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//            NSTextAttachment *attch = attrs[NSAttachmentAttributeName];
//            if (attch) {
//                attch.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
//                NSAttributedString *st = [NSAttributedString attributedStringWithAttachment:attch];
//                [mat appendAttributedString:st];
//            }else {
//                [mat appendAttributedString:[psw attributedSubstringFromRange:range]];
//            }
//        }];
//
//        [self pasteAttributedText:[mat copy] settingBlock:^(NSMutableAttributedString *attributedText) {
//            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
//        }];
//    }
//}
@end
