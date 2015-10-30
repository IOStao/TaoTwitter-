//
//  TaoLoginManager.h
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoLoginManager : NSObject

@property (nonatomic, readonly) TaoAccountItem *currentUserEntity;

+ (id)standardUserDefaults;
- (void)saveAccount:(NSMutableArray *)account;
- (NSMutableArray *)account;
- (BOOL)isLogin;

@end
