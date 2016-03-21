//
//  TaoAppDelegate.m
//  TaoTwitter
//
//  Created by wzt on 15/10/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAppDelegate.h"
#import "TaoAccountViewModel.h"
#import "TaoLoginViewController.h"
#import <WeiboSDK/WeiboSDK.h>
#import "NBNavigationViewController.h"
#import "TaoLoginManager.h"
#import "NBTabBarViewController.h"

#import "YYFPSLabel.h"

@interface TaoAppDelegate ()<WeiboSDKDelegate>

@end

@implementation TaoAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:TaoAppKey];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NBNavigationViewController *nav  = [[NBNavigationViewController alloc]initWithRootViewController:[[TaoLoginViewController alloc]init]];
    
    if ([[TaoLoginManager standardUserDefaults] isLogin]) {
        
        NBTabBarViewController *vc = [[NBTabBarViewController alloc] init];
        nav.navigationBar.hidden = YES;
        [nav setNavigationBarHidden:YES animated:NO];
        [nav pushViewController:vc animated:NO];
    }
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    [self p_showYYFPSLabel];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self ];
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if (NULL == [(WBAuthorizeResponse *)response accessToken])return;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"response"] = (WBAuthorizeResponse *)response;
    [TaoNotificationCenter postNotificationName:TaoAccountSSOSuccessNotification object:nil userInfo:userInfo];
}

- (void)p_showYYFPSLabel {
    YYFPSLabel *label = [[YYFPSLabel alloc]initWithFrame:CGRectMake(TaoScreenWidth/2 - 25 - 50,0, 50, 20)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:label];
    });
}
@end
