//
//  TaoStatuesViewLayout.h
//  TaoTwitter
//
//  Created by wzt on 15/12/11.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYTextLayout,TaoTwitterPicturesLayout;

@interface TaoStatuesViewLayout : NSObject

@property (nonatomic, strong) Taostatus *twitter;
@property (nonatomic, assign) CGRect     userImageFrame;
@property (nonatomic, assign) CGRect     userNameFrame;
@property (nonatomic, assign) CGRect     vipImageFrame;
@property (nonatomic, assign) CGRect     timeFrame;
@property (nonatomic, assign) CGRect     deviceFrame;
@property (nonatomic, assign) CGRect     statuesFrame;
@property (nonatomic, assign) CGRect     photosViewFrame;
@property (nonatomic, assign) CGFloat    statuesViewHeight;


@property (strong,nonatomic) YYTextLayout *userNameLayout;
@property (strong,nonatomic) YYTextLayout *timeLayout;
@property (strong,nonatomic) YYTextLayout *deviceLayout;
@property (strong,nonatomic) YYTextLayout *statuesLayout;
@property (strong,nonatomic) TaoTwitterPicturesLayout *pictureLayout;
@end
