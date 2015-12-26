//
//  UIPasteboard+AttributedSring.h
//  TaoTwitter
//
//  Created by wzt on 15/12/24.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPasteboard (AttributedSring)
@property(copy,nonatomic) NSAttributedString *attributString;
- (NSString *)mateTextFromAttributString:(NSAttributedString *)attributString;
@end
