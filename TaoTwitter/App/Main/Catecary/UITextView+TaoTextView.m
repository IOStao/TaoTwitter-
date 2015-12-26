//
//  NSObject+TaoTextView.m
//  TaoTwitter
//
//  Created by wzt on 15/12/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "UITextView+TaoTextView.h"

@implementation UITextView (TaoTextView)

- (void)insertAttributedText:(NSAttributedString *)text {
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    [attributedText appendAttributedString:self.attributedText];
    
    NSUInteger loc = self.selectedRange.location;
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    if (settingBlock) {
        settingBlock(attributedText);
    }
    
    self.attributedText = [attributedText copy];
    
    self.selectedRange = NSMakeRange(loc + 1, 0);
}

- (void)pasteAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock{

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    [attributedText appendAttributedString:self.attributedText];

    
    NSUInteger loc = self.selectedRange.location;
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    if (settingBlock) {
        settingBlock(attributedText);
    }

    
    self.attributedText = attributedText;
    self.selectedRange = NSMakeRange(loc + text.length+1, 0);
}
@end
