//
//  TaoComposeTextLableRegexKitLiteTool.h
//  TaoTwitter
//
//  Created by wzt on 15/12/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoComposeTextLableRegexKitLiteTool : NSObject
+ (instancetype)shared;

- (NSAttributedString *)attributedTextWithText:(NSString *)text attributedText:(NSAttributedString *)attributedText font:(UIFont *)font;

@end
