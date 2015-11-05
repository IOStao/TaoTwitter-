//
//  TaoFileManager.h
//  TaoTwitter
//
//  Created by wzt on 15/10/30.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, NBDirectory) {
    NBDirectoryDefault,
    NBDirectoryDocument,
    NBDirectoryCache,
    NBDirectoryTemp
};

@interface TaoFileManager : NSObject<Singleton>
#pragma mark ============= 沙盒文件夹便利获取 =============
- (NSString *)documentPath;
- (NSString *)libraryCachePath;
- (NSString *)tempPath;

#pragma mark ============= 存储读取 =============
- (void)storeObject:(NSObject *)object inDirectory:(NBDirectory)directory fileName:(NSString *)fileName;
- (id)readObjectFromDirectory:(NBDirectory)directory fileName:(NSString *)fileName;
- (void)storeJSONModel:(JSONModel *)obj inDirectory:(NBDirectory)directory fileName:(NSString *)fileName;
- (void)storeJSON:(id)obj inDirectory:(NBDirectory)directory fileName:(NSString *)fileName;
- (id)readJSONFromDirectory:(NBDirectory)directory fileName:(NSString *)fileName;
- (void)deleteFromDirectory:(NBDirectory)directory fileName:(NSString *)fileName;


@end
