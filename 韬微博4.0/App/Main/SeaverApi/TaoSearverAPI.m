//
//  TaoSearverAPI.m
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoSearverAPI.h"

@implementation TaoSearverAPI@end
@implementation TaoUser @end

@implementation TaoAccountItems

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.items forKey:@"TaoAccountItems"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.items = [decoder decodeObjectForKey:@"TaoAccountItems"];
    }
    return self;
}


@end
@implementation TaoAccountItem

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.accessToken forKey:@"TaoAccountItems"];
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [encoder encodeObject:self.expirationDate forKey:@"expirationDate"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
        self.expirationDate = [decoder decodeObjectForKey:@"expirationDate"];
    }
    return self;
}


@end