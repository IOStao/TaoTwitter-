//
//  TaoHTTP.h
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

typedef NS_ENUM(NSInteger, TaoNetManagerResultCode) {
    TaoNetManagerResultCodeSuccess,       // 请求结果成功
    TaoNetManagerResultCodeFail,          // 请求结果失败
    TaoNetManagerResultCodeNotModified,   // 请求返回304
};

#define CustomNetManagerErrorDomain @"www.weibo.com"
typedef NS_ENUM(NSInteger, TaoCustomNetManagerErrorType) {
    TaoCustomNetManagerErrorTypeSuccess = 0,        //网络请求成功
    TaoCustomNetManagerErrorTypeFailed  = -1,        //网络请求失败
    TaoCustomNetManagerErrorTypeNoneBuffer  = -2,    //没有缓存
    TaoCustomNetManagerErrorTypeNoneNetWork  = -3,    //没有网络
    TaoCustomNetManagerErrorTypeNoData  = -4,    //数据为空
    TaoCustomNetManagerErrorTypeParseJsonError  = -5,    //解析json失败, 多半是后端404页
    TaoCustomNetManagerErrorTypeResultObjectNull  = -6,
    TaoCustomNetManagerErrorTypeTimedOut = -7,    // 超时了
    TaoCustomNetManagerErrorTypeCanceled = -8    // 请求被取消
};

typedef void (^FinishBlockWithString)(TaoNetManagerResultCode netManagerResultCode, NSString *resultString);
typedef void (^FinishBlockWithData)(TaoNetManagerResultCode netManagerResultCode, NSData *resultData);
typedef void (^FinishBlockWithObject)(NSError *error, id resultObject);

@interface TaoHTTP : AFHTTPSessionManager

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters cacheBlock:(FinishBlockWithObject)cacheCallback completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error ,TaoNetManagerResultCode netManagerResultCode))completion;

- (NSURLSessionDownloadTask *)dowloadFileWithURL:(NSString *)URLString parameters:(id)parameters allowResumeForFileDownloads:(BOOL)isAllow progress:(NSProgress * __autoreleasing *)progress toTargetPath:(NSString *)targetPath success:(void (^)(NSURLSessionDownloadTask *, NSURL *))success failure:(void (^)(NSURLSessionDownloadTask *, NSError *))failure;
@end
