//
//  TaoTwitterLayout.h
//  TaoTwitter
//
//  Created by wzt on 15/12/11.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TaoStatuesViewLayout,TaoRStatuesViewLayout,TaoTwitterCellBarLayout;
@interface TaoTwitterLayout : NSObject


@property (nonatomic, strong) Taostatus *twitter;
@property (nonatomic, assign) CGRect     rStatuesViewFrame;
@property (nonatomic, assign) CGRect     statuesViewFrame;
@property (nonatomic, assign) CGRect     toolBarFrame;
@property (nonatomic, assign) CGFloat    twitterCellHeight;
@property (nonatomic, strong) TaoRStatuesViewLayout *rStatuesViewLayout;
@property (nonatomic, strong) TaoStatuesViewLayout *statuesViewLayout;
@property (strong,nonatomic)  TaoTwitterCellBarLayout *barLayout;

@end
