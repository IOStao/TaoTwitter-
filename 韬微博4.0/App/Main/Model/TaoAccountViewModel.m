//
//  TaoAccountViewModel.m
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAccountViewModel.h"
#import "TaoLoginViewController.h"

@implementation TaoAccountViewModel

- (void)dealloc {
    [TaoNotificationCenter removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [TaoNotificationCenter addObserver:self selector:@selector(saveDateWithResphone:) name:TaoAccountSSOSuccessNotification object:nil];
        
        self.accounts = [[TaoAccountTool account]mutableCopy];
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
    TaoAccountItem *item = [[TaoAccountItem alloc] init];
    item.accessToken = [response accessToken];
    item.userID      = [response userID];
    item.expirationDate      = [response expirationDate];
    item.refreshToken      = [response refreshToken];
    
    __block BOOL flag = NO;

    if (self.accounts) {
        [self.accounts enumerateObjectsUsingBlock:^(TaoAccountItem  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[(WBAuthorizeResponse *)response userID] isEqual:obj.userID]) {
                flag = YES;
                *stop = YES;
            }
        }];
    }
    if (!flag) {
        [self loadAccountDetialInfoWithDict:[NSDictionary dictionaryWithObjectsAndKeys:item.accessToken, @"access_token", item.userID,@"uid",nil]  AndOldItem:(TaoAccountItem *)item];
    }
}

- (NSMutableArray *)accounts {
    if (!_accounts) {
        _accounts = [NSMutableArray array];
    }
    return _accounts;
}

- (void)loadAccountDetialInfoWithDict:(NSDictionary *)params AndOldItem:(TaoAccountItem *)item{
    __block TaoUser *user ;
  
    [[TaoHTTPTool sharedInstance]get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id resultObj) {
         user = [[TaoUser alloc]initWithDictionary:resultObj error:nil];
        item.user = user;
        __weak typeof(self)weakSelf = self;
        [weakSelf.accounts addObject:item];
        [TaoAccountTool saveAccount:weakSelf.accounts];
        if (_myBlock) {
            _myBlock();
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)removeAccountAtindex:(NSInteger)index {
    [_accounts removeObjectAtIndex:index];
    [TaoAccountTool saveAccount:_accounts];
}

- (void)exchangeObjectAtIndex:(NSInteger)sourceIndex withObjectAtIndex:(NSInteger)derationIndex {
    [_accounts exchangeObjectAtIndex:sourceIndex withObjectAtIndex:derationIndex];
    [TaoAccountTool saveAccount:_accounts];
}
@end
