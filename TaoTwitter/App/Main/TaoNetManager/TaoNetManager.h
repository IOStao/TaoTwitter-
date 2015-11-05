//
//  TaoNetManager.h
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaoHTTP.h"
@interface TaoNetManager : NSObject
+ (instancetype)sharedInstance;
/**
 *  请求接口格式的URL  有缓存
 *  大部分情况下 使用这个接口请求数据
 *  @param path               URL路径
 *  @param parameters         数据参数
 *  @param cacheCallback      缓存的回调
 *  @param completion         请求完成后的回调
 *  @param notModifiedBlock   304返回的回调
 *
 *  @returns  当前的NSURLSessionDataTask任务，以便后续操作
 */
/**
 *  纯净的请求
 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               completion:(FinishBlockWithObject)completionBlock;
/**
 *  带缓存
 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               cacheBlock:(FinishBlockWithObject)cacheCallback
                               completion:(FinishBlockWithObject)completionBlock;
/**
 *  有304、带缓存
 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               cacheBlock:(FinishBlockWithObject)cacheCallback
                               completion:(FinishBlockWithObject)completionBlock
                              notModified:(FinishBlockWithObject)notModifiedBlock;
/**
 *  只读取缓存
 */
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               cacheBlock:(FinishBlockWithObject)cacheCallback;


#warning 上传


/**
 *  网络状况的，这个简单，就不写那么多的注释了
 */
+ (NSString *)networkStatusMode;
+ (BOOL)isReachableNet;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;


@end
