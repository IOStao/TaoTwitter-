//
//  TaoComposeTextPart.h
//  TaoTwitter
//
//  Created by wzt on 15/12/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoComposeTextPart : NSObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;

@property (nonatomic, assign) urlType    specialtype;
@end
