//
//  TaoUserDefults.m
//  韬微博4.0
//
//  Created by wzt on 15/10/24.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoUserDefults.h"
#import "FCModel.h"

static TaoUserDefults *_userDefaults=nil;
@implementation TaoUserDefults
-(void)createTheDatabase
{
    //建表
    NSArray* sqlCreateArray = @[//------------------ 表 ----------------------
                                @"CREATE TABLE IF NOT EXISTS UserDefaults (key TEXT DEFAULT NULL,value BLOB DEFAULT NULL);",
                                //------------------索引----------------------
                                @"CREATE UNIQUE INDEX IF NOT EXISTS UserDefaults_index ON UserDefaults(key);"
                                ];
    
    for (NSString* str in sqlCreateArray) {
        [FCModel inDatabaseSync:^(FMDatabase *db) {
            if ([db executeUpdate:str]) {
                ZDLogDebug(@"Create OK!");
            };
        }];
    }
}
#pragma mark - custom
- (id)objectForKey:(NSString *)defaultName
{
    __block NSData* tempData = nil;
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT value FROM UserDefaults WHERE key = ?",defaultName];
        while ([rs next]) {
            tempData = [rs dataForColumn:@"value"];
        }
    }];
    NSDictionary* resultDict = nil;
    //ZDLogDebug(@"tempData=%@",tempData);
    if (tempData != nil) {
        resultDict =[NSKeyedUnarchiver unarchiveObjectWithData:tempData];
    }
    else{
        return nil;
    }
    //ZDLogDebug(@"resultDict=%@",resultDict);
    return [resultDict objectForKey:@"value"];
}
- (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        if ([db executeUpdate:@"REPLACE INTO UserDefaults(key,value) VALUES (?,?);",defaultName,[NSKeyedArchiver archivedDataWithRootObject:@{@"value": value}]]) {
            // ZDLogDebug(@"insert OK");
        }
    }];
}
- (void)removeObjectForKey:(NSString *)defaultName
{
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        if ([db executeUpdate:@"DELETE FROM UserDefaults WHERE key = ?",defaultName]) {
            //ZDLogDebug(@"remove OK!");
        };
    }];
}
#pragma mark - common
- (id)init
{
    self=[super init];
    if (self) {
        [self createTheDatabase];
    }
    return self;
}

+ (id)standardUserDefaults{
    static dispatch_once_t predUserDefaults;
    dispatch_once(&predUserDefaults, ^{
        _userDefaults=[[KIDUserDefaults alloc] init];
    });
    return _userDefaults;
}

+(id)alloc
{
    NSAssert(_userDefaults == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}


@end
