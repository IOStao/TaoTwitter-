//
//  TaoAccountTool.m
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAccountTool.h"
#import "TaoUserDefults.h"

@implementation TaoAccountTool

+ (void)saveAccount:(NSMutableArray *)account {
    [[TaoUserDefults standardUserDefaults]setObject:account forKey:@"accounts"];
}

+ (NSMutableArray *)account {
    NSMutableArray *items = [[TaoUserDefults standardUserDefaults]objectForKey:@"accounts"];
    
    NSDate *now = [NSDate date];
    [items enumerateObjectsUsingBlock:^(TaoAccountItem  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([now laterDate:obj.expirationDate]) {
            obj.accessToken = obj.refreshToken;
        }

    }];
    return items;
}

@end
