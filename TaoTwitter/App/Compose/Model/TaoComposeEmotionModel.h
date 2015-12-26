//
//  TaoComposeEmotionModel.h
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoComposeEmotionModel : TaoSearverAPI
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的16进制编码 */
@property (nonatomic, copy) NSString *code;
/**  删除按钮*/
@property (nonatomic, assign) BOOL  emotionDelete;
@property (nonatomic, assign) BOOL  isNotEmotion;
@end
