//
//  TaoTwitterTextPart.h
//  TaoTwitter
//
//  Created by wzt on 15/11/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TaoTwitterTextPart : NSObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;

/** 这段特殊文字的矩形框(要求数组里面存放CGRect) */
@property (nonatomic, strong) NSArray *rects;
/**特殊类型是什么*/
@property (nonatomic, assign) urlType    specialtype;

@end
