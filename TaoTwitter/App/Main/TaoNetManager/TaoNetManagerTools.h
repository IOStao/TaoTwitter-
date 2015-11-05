//
//  TaoNetManagerTools.h
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoNetManagerTools : NSObject

+ (NSError *)errorWithCode:(NSInteger)errorCode description:(NSString *)errorDescription;

+ (NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData;
@end
