//
//  TaoNetManager.m
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoNetManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "TaoNetManagerTools.h"

#define TaoHost @"https://api.weibo.com"
#define TaoHttpTimeOUtSecond 10

@interface TaoNetManager ()
@property(nonatomic) TaoHTTP *sessionManager;

@end

static NSString * kProcessIndentifier = @"KIDDownloadTaskProcessIndentifier";

@implementation TaoNetManager

+ (instancetype)sharedInstance {
    static TaoNetManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = TaoHttpTimeOUtSecond;
        _sessionManager = [[TaoHTTP alloc] initWithBaseURL:[NSURL URLWithString:TaoHost] sessionConfiguration:sessionConfig];
        
        [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:32*1024*1024 diskPath:nil]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (NSDictionary *)postParametersWithParameters:(NSDictionary *)paramsData {
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:paramsData ?: @{}];
    if ([[TaoLoginManager standardUserDefaults]isLogin]){
        paramsDict[@"access_token"] = [[[TaoLoginManager standardUserDefaults] currentUserEntity]accessToken] ;
        return [paramsDict copy];
    } else {
        return paramsData;
    }
}

- (NSString *)completeAddressWithPath:(NSString *)url {
    return [NSString stringWithFormat:@"%@/2/%@", TaoHost, url];
}

- (id)objectWithDictionary:(NSDictionary *)dict address:(NSString *)url {
   
    NSRange range;
    range.location = [url rangeOfString:@"/2/"].location + 3;
    range.length = [url rangeOfString:@"/" options:NSBackwardsSearch].location - range.location;
    NSString *classname = [url substringWithRange:range];
    
    NSString *aClassName = [NSString stringWithFormat:@"Tao%@",classname];
    Class class = NSClassFromString(aClassName);
    NSError *error = nil;
    id obj = [[class alloc] initWithDictionary:dict error:&error];
    if (error) {
        TaoLog(@"%@", error);
    }
    return obj;
}

#pragma mark Requiest
- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               completion:(FinishBlockWithObject)completionBlock {
    return [self requestWithPath:path parameters:parameters cacheBlock:NULL completion:completionBlock notModified:completionBlock];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               cacheBlock:(FinishBlockWithObject)cacheCallback
                               completion:(FinishBlockWithObject)completionBlock {
    return [self requestWithPath:path parameters:parameters cacheBlock:cacheCallback completion:completionBlock notModified:completionBlock];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters cacheBlock:(FinishBlockWithObject)cacheCallback {
    return [self requestWithPath:path parameters:parameters cacheBlock:cacheCallback completion:NULL notModified:NULL];
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters cacheBlock:(FinishBlockWithObject)cacheCallback completion:(FinishBlockWithObject)completionBlock notModified:(FinishBlockWithObject)notModifiedBlock {
    NSString *addrerss = [self completeAddressWithPath:path];
    parameters = [self postParametersWithParameters:parameters];
    
    NSURLSessionDataTask *requst = [_sessionManager requestWithPath:addrerss parameters:parameters cacheBlock:^(NSError *error, id resultObject) {
        if (cacheCallback && resultObject) {
            NSDictionary *resultDict = [TaoNetManagerTools dictionaryFromJSONData:resultObject];
            id result = nil;
            if ([resultDict isKindOfClass:[NSDictionary class]]) {
                result = [self objectWithDictionary:resultDict address:addrerss];
                if (0 != [resultDict[@"errNo"] intValue]) {
                    error = [TaoNetManagerTools errorWithCode:[resultDict[@"errNo"] intValue] description:resultDict[@"errstr"]];
                }
            else {
                error = [TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeParseJsonError description:@"咦，没有网络了"];
            }
            cacheCallback(error, result);
         }
     }
    } completion:^(NSURLResponse *response, id responseObject, NSError *error, TaoNetManagerResultCode netManagerResultCode) {
        NSDictionary *resultDict = [TaoNetManagerTools dictionaryFromJSONData:responseObject];
        
        id netObject = nil;
        if ([resultDict isKindOfClass:[NSDictionary class]]) {
            netObject = [self objectWithDictionary:resultDict address:addrerss];
            if (0 != [resultDict[@"errNo"] intValue]) {
                error = [TaoNetManagerTools errorWithCode:[resultDict[@"errNo"] intValue] description:resultDict[@"errstr"]];
            }
        } else if (!error) {
            error = [TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeParseJsonError description:@"咦，没有网络了"];
        }
        if (netManagerResultCode == TaoNetManagerResultCodeNotModified) {
            if (notModifiedBlock) {
                notModifiedBlock(error, netObject);
            }
        }
        else{
            if (completionBlock) {
                completionBlock(error, netObject);
            }
        }
    }];
    
    return requst;
}

+ (NSString *)networkStatusMode {
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:return @"NoInternet";
        case AFNetworkReachabilityStatusReachableViaWiFi:return @"Wifi";
        case AFNetworkReachabilityStatusReachableViaWWAN:return @"2G/3G";
        case AFNetworkReachabilityStatusUnknown:
        default:return @"未知错误";
    }
}

+ (BOOL)isReachableNet {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isReachableViaWWAN {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isReachableViaWiFi {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

@end
