//
//  TaoHTTPTool.h
//  韬微博4.0
//
//  Created by wzt on 15/10/24.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TaoHTTPTool : NSObject

+ (instancetype)sharedInstance;
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
