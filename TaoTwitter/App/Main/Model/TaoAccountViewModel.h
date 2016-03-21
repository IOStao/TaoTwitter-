//
//  TaoAccountViewModel.h
//  TaoTwitter
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//
typedef void(^finishBlack)(void);
#import <Foundation/Foundation.h>
#import <WeiboSDK/WeiboSDK.h>


@interface TaoAccountViewModel : NSObject
@property (nonatomic,readonly) NSMutableArray *accounts;
@property(nonatomic, copy)finishBlack myBlock;


- (void)loadData;
- (void)saveDateWithResphone:(WBBaseResponse *)response;
- (void)removeAccountAtindex:(NSInteger)index;
- (void)exchangeObjectAtIndex:(NSInteger)sourceIndex withObjectAtIndex:(NSInteger)derationIndex;
@end
