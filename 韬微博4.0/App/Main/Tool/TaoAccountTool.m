//
//  TaoAccountTool.m
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAccountTool.h"

#define TaoAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation TaoAccountTool

+ (void)saveAccount:(TaoAccountItems *)account {
    [NSKeyedArchiver archiveRootObject:account toFile:TaoAccountPath];
}

+ (TaoAccountItems *)account {
    TaoAccountItems *items = [NSKeyedUnarchiver unarchiveObjectWithFile:TaoAccountPath];
    
    NSDate *now = [NSDate date];
    [items.items enumerateObjectsUsingBlock:^(TaoAccountItem  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([now laterDate:obj.expirationDate]) {
            obj.accessToken = obj.refreshToken;
        }

    }];
    return items;
}

@end
