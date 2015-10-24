//
//  TaoAccountViewModel.h
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//
typedef void(^finishBlack)(void);
#import <Foundation/Foundation.h>
#import <WeiboSDK/WeiboSDK.h>
#import "TaoAccountTool.h"

@interface TaoAccountViewModel : NSObject

@property(nonatomic, copy)finishBlack myBlock;
@property (nonatomic, strong) __block NSMutableArray *accounts;

- (void)loadData;
- (void)saveDateWithResphone:(WBBaseResponse *)response;
- (void)removeAccountAtindex:(NSInteger)index;
- (void)exchangeObjectAtIndex:(NSInteger)sourceIndex withObjectAtIndex:(NSInteger)derationIndex;
@end
