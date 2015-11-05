//
//  TaoNetManagerTools.m
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoNetManagerTools.h"

@implementation TaoNetManagerTools

#define CustomNetManagerErrorDomain @"www.weibo.com"

+ (NSError *)errorWithCode:(NSInteger)errorCode description:(NSString *)errorDescription {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:CustomNetManagerErrorDomain code:errorCode userInfo:userInfo];
}

+ (NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData {
    if ([jsonData isKindOfClass:[NSData class]]) {
        NSDictionary *dict;
        NSError *error;
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if ([dict isKindOfClass:[NSDictionary class]] && error == nil) {
            return dict;
        }
    }
    return nil;
}

@end
