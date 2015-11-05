//
//  TaoFileManager.m
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//


#import "TaoFileManager.h"
#import <objc/runtime.h>
#define FileManagerStoreDirectory @"com.TaoTwitter.fileManager"

@interface  TaoFileManager ()
@property (nonatomic, strong) dispatch_queue_t  cache_io_queue;
@property (nonatomic, strong) NSString          *documentPath;
@property (nonatomic, strong) NSString          *cachePath;
@property (nonatomic, strong) NSString          *tempPath;
@end

@implementation TaoFileManager
- (instancetype)init {
    self = [super init];
    if (self) {
        
#pragma mark ============= TODOP 参考ASI进行磁盘文件管理. =============
        _cache_io_queue = dispatch_queue_create("com.TaoTwitter.fileManager", 0);
        [self initPath];
        [self createDirectory];
        
    }
    return self;
}

- (void)initPath {
    _documentPath = [[self documentPath] stringByAppendingPathComponent:FileManagerStoreDirectory];
    _tempPath = [[self tempPath] stringByAppendingPathComponent:FileManagerStoreDirectory];
    _cachePath = [[self libraryCachePath] stringByAppendingPathComponent:FileManagerStoreDirectory];
}

- (void)createDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:self.documentPath]) {
        [fileManager createDirectoryAtPath:self.documentPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:self.tempPath]) {
        [fileManager createDirectoryAtPath:self.tempPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    if(![fileManager fileExistsAtPath:self.cachePath]) {
        [fileManager createDirectoryAtPath:self.cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

/*
 Documents 目录：您应该将所有de应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
 */
- (NSString *)documentPath {
    if (_documentPath) {
        return _documentPath;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

/*
 * Library 目录：这个目录下有两个子目录：Caches 和 Preferences
 Preferences 目录：包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
 Caches 目录：用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
 */
- (NSString *)libraryCachePath {
    if (_cachePath) {
        return _cachePath;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return cachesDir;
}

/*
 * tmp 目录：这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
 */
- (NSString *)tempPath {
    if (_tempPath) {
        return _tempPath;
    }
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

- (NSString *)directoryPath:(NBDirectory)directory {
    switch (directory) {
        case NBDirectoryCache:
            return _cachePath;
            break;
        case NBDirectoryDocument:
            return _documentPath;
            break;
        case NBDirectoryTemp:
            return _tempPath;
            break;
        default:
            return _cachePath;
            break;
    }
}

- (NSString *)wholePath:(NBDirectory)directory fileName:(NSString *)name {
    NSString * fullPath = [[self directoryPath:directory] stringByAppendingPathComponent:name];
    return fullPath;
}

- (void)storeObject:(NSObject *)object inDirectory:(NBDirectory)directory fileName:(NSString *)fileName {
    if (object != nil && fileName != nil) {
        [NSKeyedArchiver archiveRootObject:object toFile:[self wholePath:directory fileName:fileName]];
    }
}
#pragma mark ============= TODOP trycatch? =============
- (id)readObjectFromDirectory:(NBDirectory)directory fileName:(NSString *)fileName {
    id object = nil;
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self wholePath:directory fileName:fileName]];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return object;
}

/**
 *  过滤 JSONModel 生成字典中的多余信息，用于存储数据
 */
- (id)filterExtraKeys:(id)obj {
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = [obj mutableCopy];
        for (NSUInteger i=0; i < result.count; i++) {
            result[i] = [self filterExtraKeys:result[i]];
        }
        return result;
    }
    
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    
    NSMutableDictionary *result = [obj mutableCopy];
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([TaoSearverAPI class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        [result removeObjectForKey:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    
    NSArray *keys = [result allKeys];
    [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        [result setValue:[self filterExtraKeys:result[key]] forKey:key];
    }];
    
    free(properties);
    
    return result;
}

- (void)storeJSONModel:(JSONModel *)obj inDirectory:(NBDirectory)directory fileName:(NSString *)fileName {
    NSMutableDictionary *dict = [[obj toDictionary] mutableCopy];
    dict = [self filterExtraKeys:dict];
    [self storeJSON:dict inDirectory:directory fileName:fileName];
}

- (void)storeJSON:(id)obj inDirectory:(NBDirectory)directory fileName:(NSString *)fileName {
    if (!obj) {
        return;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&error];
    
    if (!error) {
        [jsonData writeToFile:[self wholePath:directory fileName:fileName] atomically:YES];
    }
}

- (id)readJSONFromDirectory:(NBDirectory)directory fileName:(NSString *)fileName {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[self wholePath:directory fileName:fileName]];
    NSError *error;
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    return nil;
}

- (void)deleteFromDirectory:(NBDirectory)directory fileName:(NSString *)fileName {
    [[NSFileManager defaultManager] removeItemAtPath:[self wholePath:directory fileName:fileName] error:nil];
}

#pragma mark ============= TODOP =============
@end
