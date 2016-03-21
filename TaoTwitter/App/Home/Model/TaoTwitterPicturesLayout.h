//
//  TaoTwitterPictureLayout.h
//  TaoTwitter
//
//  Created by wzt on 15/12/29.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoTwitterPicturesLayout : NSObject
@property (strong,nonatomic) Taostatus *twitter;
@property (strong,nonatomic) NSMutableArray *frameArry;
@property (assign,nonatomic) CGSize     pictureSize;
@end
