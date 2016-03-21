//
//  TaoAccountViewModel.m
//  TaoTwitter
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAccountViewModel.h"
#import "TaoLoginViewController.h"
#import "TaoNetManager.h"
#import <MBProgressHUD.h>

@interface TaoAccountViewModel ()
@property (nonatomic, strong) __block NSMutableArray *accounts;

@end

@implementation TaoAccountViewModel

- (void)dealloc {
    [TaoNotificationCenter removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [TaoNotificationCenter addObserver:self selector:@selector(saveDateWithResphone:) name:TaoAccountSSOSuccessNotification object:nil];
        
        self.accounts = [[[TaoLoginManager standardUserDefaults]account]mutableCopy];
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
    __weak typeof(self)weakSelf = self;
    
    [[TaoNetManager sharedInstance] requestWithPath:@"users/show.json" parameters:params cacheBlock:^(NSError *error, Taousers *resultObject) {
        if(!error) {
            item.user = resultObject;
            [weakSelf.accounts addObject:item];
            [[TaoLoginManager standardUserDefaults] saveAccount:weakSelf.accounts];
            if (_myBlock) {
                _myBlock();
            }
        }
    } completion:^(NSError *error, Taousers *resultObject) {
        if(!error) {
            item.user = resultObject;
            [weakSelf.accounts addObject:item];
            [[TaoLoginManager standardUserDefaults] saveAccount:weakSelf.accounts];
            if (_myBlock) {
                _myBlock();
            }else {
                MBProgressHUD *hud = [[MBProgressHUD alloc] init];
                hud = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication].windows lastObject]];
                [[UIApplication sharedApplication].windows.lastObject  addSubview:hud];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red-x"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"保存失败";
                [hud show:YES];
                [hud hide:YES afterDelay:1];
            }
        }
    }];
 
}

- (void)removeAccountAtindex:(NSInteger)index {
    [_accounts removeObjectAtIndex:index];
    [[TaoLoginManager standardUserDefaults] saveAccount:_accounts];
    [TaoNotificationCenter postNotificationName:TaoAccountLogout object:nil];
}

- (void)exchangeObjectAtIndex:(NSInteger)sourceIndex withObjectAtIndex:(NSInteger)derationIndex {
    [_accounts exchangeObjectAtIndex:sourceIndex withObjectAtIndex:derationIndex];
    [[TaoLoginManager standardUserDefaults] saveAccount:_accounts];
}
@end
