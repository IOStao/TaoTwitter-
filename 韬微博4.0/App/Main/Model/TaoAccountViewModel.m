//
//  TaoAccountViewModel.m
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAccountViewModel.h"

#import "TaoLoginViewController.h"
#import "TaoHTTPTool.h"
@implementation TaoAccountViewModel

- (void)dealloc {
    [TaoNotificationCenter removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [TaoNotificationCenter addObserver:self selector:@selector(saveDateWithResphone:) name:TaoAccountSSOSuccessNotification object:nil];
    }
    return self;
}

- (void)loadData {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = TaoRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)saveDateWithResphone:(NSNotification *)useInfo {
    WBAuthorizeResponse *response = [useInfo.userInfo valueForKey:@"response"];
    if (!response)return;
    TaoAccountItem *item = [[TaoAccountItem alloc] init];
    item.accessToken = [response accessToken];
    item.userID      = [response userID];
    item.expirationDate      = [response expirationDate];
    item.refreshToken      = [response refreshToken];
    
    __block BOOL flag = NO;
    TaoAccountItems *itemarrays = [TaoAccountTool account];
    if (!itemarrays.items) {
        itemarrays = [[TaoAccountItems alloc] init];
        itemarrays.items = [NSMutableArray<TaoAccountItem> array];
        [itemarrays.items addObject:item];
    } else {
        [itemarrays.items enumerateObjectsUsingBlock:^(TaoAccountItem  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[(WBAuthorizeResponse *)response userID] isEqual:obj.userID]) {
                flag = YES;
                *stop = YES;
            }
        }];
    }
    if (!flag) {
        [self loadAccountDetialInfoWithDict:[NSDictionary dictionaryWithObjectsAndKeys:item.accessToken, @"access_token", item.userID,@"uid",nil]];
        [itemarrays.items addObject:item];
        [TaoAccountTool saveAccount:itemarrays];
        _accounts = [itemarrays.items mutableCopy];
    }
}

- (NSMutableArray *)accounts {
    if (!_accounts) {
        _accounts = [NSMutableArray array];
        TaoAccountItems *itemarrays = [TaoAccountTool account];
        _accounts = [itemarrays.items mutableCopy];
    }
    return _accounts;
}

- (void)loadAccountDetialInfoWithDict:(NSDictionary *)params {
    
    [[TaoHTTPTool sharedInstance]get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id resultObj) {
        self.user = [[TaoUser alloc]initWithDictionary:resultObj error:nil];
        if (_myBlock) {
            _myBlock();
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
