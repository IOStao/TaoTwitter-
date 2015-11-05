//
//  TaoHTTP.m
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoHTTP.h"
#import "TaoNetManagerTools.h"
#import "TaoFileManager.h"
#import "NSURLSessionDownloadTask+Resume.h"

@interface TaoHTTP ()
@property (nonatomic, strong) NSMutableDictionary *URLCacheKeyRequestsByTaskIdentifiers;
@property (nonatomic, strong) NSMutableArray *cacheHandlerObservers;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation TaoHTTP

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self  = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/javascript",@"application/json",@"text/plain",@"text/html",@"application/xhtml+xml",@"application/xml",nil];
        self.responseSerializer = serializer;
        _cacheHandlerObservers = [NSMutableArray array];
        _URLCacheKeyRequestsByTaskIdentifiers = [NSMutableDictionary dictionary];
        [self registerCacheHandlerObservers];
    }
    return self;
}

- (NSURLSessionDataTask *)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters cacheBlock:(FinishBlockWithObject)cacheCallback completion:(void (^)(NSURLResponse *, id, NSError *, TaoNetManagerResultCode))completion {
     NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:path parameters:parameters error:&serializationError];
    [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
    if (serializationError) {
        if (completion) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                completion(nil,nil,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeNoneNetWork description:@"咦，没有网络了"],TaoNetManagerResultCodeFail);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    //生成304用的东西
    NSURLCache *URLCache = self.session.configuration.URLCache ?: [NSURLCache sharedURLCache];
    NSCachedURLResponse *cachedURLResponse = [URLCache cachedResponseForRequest:request];
    if (cachedURLResponse) {
        [request setValue:[(NSHTTPURLResponse*)cachedURLResponse.response allHeaderFields][@"ETag"]?:@"" forHTTPHeaderField:@"If-None-Match"];
    }
    __block NSURLSessionDataTask *dataTask = nil;
    __weak typeof(self) weakSelf = self;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *  response, id   responseObject, NSError *  error) {
        if (error) {
            switch (error.code) {
                case NSURLErrorNotConnectedToInternet:
                    completion(response,responseObject,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeNoneNetWork description:@"咦，没有网络了"],TaoNetManagerResultCodeFail);
                    break;
                case NSURLErrorBadServerResponse: //忽视了本地的缓存，服务器还不返回数据，肯定会认为server端错误了
                    if ([(NSHTTPURLResponse*)response statusCode] == 304) {
                        [self getCachedURLResponseWithTask:dataTask responseSerialization:self.responseSerializer completionHandler:^(NSError *error, id resultObject) {
                            completion(response,resultObject,nil,TaoNetManagerResultCodeNotModified);
                        }];
                    }
                    else{
                        completion(response,responseObject,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeFailed description:@"咦，没有网络了"],TaoNetManagerResultCodeFail);
                    }
                    break;
                case NSURLErrorTimedOut:
                    completion(response,responseObject,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeTimedOut description:@"咦，没有网络了"],TaoNetManagerResultCodeFail);
                    break;
                case NSURLErrorNetworkConnectionLost:
                    completion(response,responseObject,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeNoneNetWork description:@"咦，没有网络了"],TaoNetManagerResultCodeFail);
                    break;
                case NSURLErrorCannotFindHost:
                    completion(response,responseObject,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeNoneNetWork description:@"咦，没有网络了"],TaoNetManagerResultCodeFail);
                    break;
                case NSURLErrorCancelled:
                    completion(response,responseObject,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeCanceled description:@""], TaoNetManagerResultCodeFail);
                    break;
                default:
                    completion(response,responseObject,[TaoNetManagerTools errorWithCode:TaoCustomNetManagerErrorTypeFailed description:@"咦，没有网络了"], TaoNetManagerResultCodeFail);
                    break;
            }
        }
        else {
            if (weakSelf.responseSerializer && responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [weakSelf.responseSerializer responseObjectForResponse:response data:responseObject error:&error];
                }
            }
            if (completion) {
                completion(response,responseObject,nil,TaoNetManagerResultCodeSuccess);
            }
        }
    }];
    [self addURLCacheKeyRequestForTask:dataTask];
    if (cacheCallback) {
        [self getCachedURLResponseWithTask:dataTask responseSerialization:self.responseSerializer completionHandler:cacheCallback];
    }
    [dataTask resume];
    return dataTask;

}

- (void)dealloc
{
    [self unregisterCacheHandlerObservers];
}
#pragma mark - Cache
- (void)unregisterCacheHandlerObservers
{
    [self.cacheHandlerObservers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj];
    }];
    [self.cacheHandlerObservers removeAllObjects];
}

- (void)registerCacheHandlerObservers
{
    [self unregisterCacheHandlerObservers];
    __weak __typeof(self) weakSelf = self;
    id taskDidCompleteObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingTaskDidCompleteNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        NSURLSessionTask *task = note.object;
        NSError *error = note.userInfo[AFNetworkingTaskDidCompleteErrorKey];
        NSData *data = note.userInfo[AFNetworkingTaskDidCompleteResponseDataKey];
        NSURLRequest *URLCacheKeyRequest = [strongSelf URLCacheKeyRequestForTask:task];
        [strongSelf removeURLCacheKeyRequestFoTask:task];
        
        BOOL isResumeTask = NO;
        if ([task respondsToSelector:@selector(kid_allowResume)]) {
            isResumeTask = YES;
        }
        if (isResumeTask) {
            if (error) {
                data =  error.userInfo[NSURLSessionDownloadTaskResumeData];
                BOOL isValidError = [weakSelf isValidError:error];
                if (!isValidError) {
                    [[TaoFileManager sharedInstance_ks] deleteFromDirectory:NBDirectoryTemp fileName:[weakSelf downloadTaskURLIndentifier:URLCacheKeyRequest]];
                    return ;
                }
                if (!data) {
                    return;
                }
            }
        }else{
            if (error) {
                return;
            }
            if (!data) {
                return;
            }
        }
        
        if (!URLCacheKeyRequest) {
            return;
        }
        
        if (isResumeTask) {
            if (error) {
                [[TaoFileManager sharedInstance_ks] storeObject:data inDirectory:NBDirectoryTemp fileName:[weakSelf downloadTaskURLIndentifier:URLCacheKeyRequest]];
            }
            else{
                [[TaoFileManager sharedInstance_ks] deleteFromDirectory:NBDirectoryTemp fileName:[weakSelf downloadTaskURLIndentifier:URLCacheKeyRequest]];
            }
        }
        else{
            if (!error) {
                NSURLCache *URLCache = strongSelf.session.configuration.URLCache ?: [NSURLCache sharedURLCache];
                NSCachedURLResponse *cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:task.response data:data];
                [URLCache storeCachedResponse:cachedURLResponse forRequest:URLCacheKeyRequest];
            }
        }
    }];
    
    id sessionDidInvalidateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AFURLSessionDidInvalidateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [weakSelf removeAllURLCacheKeyRequests];
    }];
    
    [self.cacheHandlerObservers addObject:taskDidCompleteObserver];
    [self.cacheHandlerObservers addObject:sessionDidInvalidateObserver];
}

- (BOOL)isValidError:(NSError *)error{
    if (error.code == NSURLErrorNotConnectedToInternet ||
        error.code == NSURLErrorBadServerResponse ||
        error.code == NSURLErrorTimedOut ||
        error.code == NSURLErrorNetworkConnectionLost||
        error.code == NSURLErrorCannotFindHost) {
        return YES;
    }
    return NO;
}

- (NSString *)downloadTaskURLIndentifier:(NSURLRequest *)request {
    if (request.URL.absoluteString.length > 0) {
        return [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    return @"";
}
// 给task添加一个可以拉取cache的request，因为POST是非幂等的万万是不能从URLCahce中取缓存了
- (void)addURLCacheKeyRequestForTask:(NSURLSessionTask *)task
{
    NSURLRequest *URLCacheKeyRequest = task.originalRequest;
    if (!URLCacheKeyRequest) {
        return;
    }
    [self.lock lock];
    self.URLCacheKeyRequestsByTaskIdentifiers[@(task.taskIdentifier)] = URLCacheKeyRequest;
    [self.lock unlock];
}

- (NSURLRequest *)URLCacheKeyRequestForTask:(NSURLSessionTask *)task
{
    [self.lock lock];
    NSURLRequest *URLCacheKeyRequest = self.URLCacheKeyRequestsByTaskIdentifiers[@(task.taskIdentifier)];
    [self.lock unlock];
    return URLCacheKeyRequest;
}

- (void)removeURLCacheKeyRequestFoTask:(NSURLSessionTask *)task
{
    [self.lock lock];
    [self.URLCacheKeyRequestsByTaskIdentifiers removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

- (void)removeAllURLCacheKeyRequests
{
    [self.lock lock];
    [self.URLCacheKeyRequestsByTaskIdentifiers removeAllObjects];
    [self.lock unlock];
}

// 取出task对应的cache
- (void)getCachedURLResponseWithTask:(NSURLSessionDataTask *)dataTask responseSerialization:(id<AFURLResponseSerialization>)serializer completionHandler:(FinishBlockWithObject)completion
{
    id cachedObject = nil;
    if (dataTask) {
        NSURLCache *URLCache = self.session.configuration.URLCache ?: [NSURLCache sharedURLCache];
        NSURLRequest *URLCacheKeyRequest = [self URLCacheKeyRequestForTask:dataTask];
        if (!URLCacheKeyRequest) {
            URLCacheKeyRequest = dataTask.originalRequest;
        }
        
        NSCachedURLResponse *cachedURLResponse = [URLCache cachedResponseForRequest:URLCacheKeyRequest];
        if (cachedURLResponse) {
            if (serializer) {
                cachedObject = [serializer responseObjectForResponse:cachedURLResponse.response data:cachedURLResponse.data error:nil];
            }
            else {
                cachedObject = cachedURLResponse.data;
            }
        }
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    if (!self.completionQueue && [NSThread isMainThread]) {
        completion(nil, cachedObject);
    } else {
        dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
            completion(nil, cachedObject);
        });
    }
#pragma clang diagnostic pop
}@end
