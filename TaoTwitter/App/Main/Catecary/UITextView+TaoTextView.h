//
//  NSObject+TaoTextView.h
//  TaoTwitter
//
//  Created by wzt on 15/12/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITextView (TaoTextView)
- (void)pasteAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;
- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;
@end
