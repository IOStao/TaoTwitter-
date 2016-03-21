//
//  TaoRegexKitLiteTool.h
//  TaoTwitter
//
//  Created by wzt on 15/11/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TaoTwitterTextLableRegexKitLiteTool : NSObject

+ (instancetype)shared;

- (NSAttributedString *)attributedTextWithText:(NSString *)text font:(UIFont *)font;
- (NSAttributedString *)pastAttributedTextWithText:(NSString *)text font:(UIFont *)font;
@end
