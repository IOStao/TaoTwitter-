//
//  TaoLoginManager.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoLoginManager.h"
#import "TaoUserDefults.h"
#import "NBTabBarViewController.h"

NSString *const key = @"currentUser";
@interface TaoLoginManager ()
@property (nonatomic, strong) TaoAccountItem *currentUserEntity;
@end


@implementation TaoLoginManager
static  TaoLoginManager *_taoLoginManager=nil;

- (void)dealloc {
    [TaoNotificationCenter removeObserver:self];
}

+ (id)standardUserDefaults {
    static dispatch_once_t predUserDefaults;
    dispatch_once(&predUserDefaults, ^{
        _taoLoginManager=[[TaoLoginManager alloc] init];
    });
    return _taoLoginManager;
    
}

- (instancetype)init {
    if (self = [super init]) {
        [TaoNotificationCenter addObserver:self selector:@selector(savaUserEntity:) name:TaoAccountLogin object:nil];
        [TaoNotificationCenter addObserver:self selector:@selector(UserLogout) name:TaoAccountLogout object:nil];
        
    }
    return self;
}

- (void)saveAccount:(NSMutableArray *)account {
    [[TaoUserDefults standardUserDefaults]setObject:account forKey:@"accounts"];
}

- (NSMutableArray *)account {
    NSMutableArray *items = [[TaoUserDefults standardUserDefaults]objectForKey:@"accounts"];
    
    NSDate *now = [NSDate date];
    [items enumerateObjectsUsingBlock:^(TaoAccountItem  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![now laterDate:obj.expirationDate]) {
            obj.accessToken = obj.refreshToken;
        }
        
    }];
    return items;
}

- (TaoAccountItem *)currentUserEntity {
    if (!_currentUserEntity) {
        _currentUserEntity = [[TaoUserDefults standardUserDefaults]objectForKey:key]? [[TaoUserDefults standardUserDefaults]objectForKey:key] :[[TaoAccountItem alloc] init];
    }
    return _currentUserEntity;
}

- (void)savaUserEntity:(NSNotification *)dict{
    NSNumber *br = [dict.userInfo objectForKey:@"uid"];
    NSInteger index = [br integerValue];
    self.currentUserEntity = [[_taoLoginManager account]objectAtIndex:index];
    [[TaoUserDefults standardUserDefaults]setObject:self.currentUserEntity forKey:key];
}

- (void)UserLogout {
    [[TaoUserDefults standardUserDefaults]removeObjectForKey:key];
}

- (BOOL)hasLogin {
    return self.currentUserEntity.userID !=nil;
}

- (BOOL)isLogin {
    return [self hasLogin];
}

@end
