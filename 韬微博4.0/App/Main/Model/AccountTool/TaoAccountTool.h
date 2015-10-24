//
//  TaoAccountTool.h
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoAccountTool : NSObject

+ (void)saveAccount:(NSMutableArray *)account;

+ (NSMutableArray *)account;
@end
