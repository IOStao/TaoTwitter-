//
//  TaoRStatuesViewLayout.h
//  TaoTwitter
//
//  Created by wzt on 15/12/11.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYTextLayout,TaoTwitterPicturesLayout;

@interface TaoRStatuesViewLayout : NSObject
@property (nonatomic, strong) Taostatus *rtwitter;
@property (nonatomic, assign) CGRect     rStatuesFrame;
@property (nonatomic, assign) CGRect     leftLineFrame;
@property (nonatomic, assign) CGRect     rphotosViewFrame;
@property (nonatomic, assign) CGFloat     rStatuesViewHeight;

@property (strong,nonatomic) YYTextLayout *rStatuesLayout;
@property (strong,nonatomic) TaoTwitterPicturesLayout *rPictureLayout;
@end
