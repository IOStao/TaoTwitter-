//
//  TaoUserDefults.m
//  韬微博4.0
//
//  Created by wzt on 15/10/24.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoUserDefults.h"
#import "FMDB.h"

static FMDatabase *_db;
static TaoUserDefults *_userDefaults=nil;
@implementation TaoUserDefults
-(void)createTheDatabase
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:  @"CREATE TABLE IF NOT EXISTS UserDefaults (key TEXT DEFAULT NULL,value BLOB DEFAULT NULL);"];
}
#pragma mark - custom
- (id)objectForKey:(NSString *)defaultName
{
    __block NSData* tempData = nil;
    
    FMResultSet *rs = [_db executeQuery:@"SELECT value FROM UserDefaults WHERE key = ?",defaultName];
    while ([rs next]) {
        tempData = [rs dataForColumn:@"value"];
    }
    
    NSDictionary* resultDict = nil;
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
    [_db executeUpdate:@"REPLACE INTO UserDefaults(key,value) VALUES (?,?);",defaultName,[NSKeyedArchiver archivedDataWithRootObject:@{@"value": value}]];

}
- (void)removeObjectForKey:(NSString *)defaultName {
   
    [_db executeUpdate:@"DELETE FROM UserDefaults WHERE key = ?",defaultName];
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
        _userDefaults=[[TaoUserDefults alloc] init];
    });
    return _userDefaults;
}

+(id)alloc {
    NSAssert(_userDefaults == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}


@end
