//
//  TaoUserDefults.h
//  韬微博4.0
//
//  Created by wzt on 15/10/24.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoUserDefults : NSObject

+ (id)standardUserDefaults;

- (id)objectForKey:(NSString *)defaultName;
- (void)setObject:(id)value forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;
@end
