//
//  NBTabBarViewController.m
//  TaoTwitter
//
//  Created by wzt on 15/10/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "NBTabBarViewController.h"
#import "NBNavigationViewController.h"
#import "NBTabBar.h"
#import "TaoHomeViewController.h"
#import "TaoMessageTableViewController.h"
#import "TaoMineTableViewController.h"
#import "TaoDisCoverViewController.h"
#import "TaoLoginViewController.h"



@interface NBTabBarViewController ()<NBTaBarDelegate>

@end

@implementation NBTabBarViewController

- (void)dealloc{
    NSLog(@"NBTabBarViewControllerNBTabBarViewControllerNBTabBarViewController dealloc");
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChileViewController:[[TaoHomeViewController alloc] init] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addChileViewController:[[TaoMessageTableViewController alloc] init] title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    [self addChileViewController:[[TaoDisCoverViewController alloc] init] title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    [self addChileViewController:[[TaoMineTableViewController alloc] init] title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    NBTabBar *tabar = [[NBTabBar alloc] init];
    [self setValue:tabar forKey:@"tabBar"];
    [self.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2.5)];
    
    [self.navBarConfig configBarItems];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChileViewController:(UIViewController *)childvc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    childvc.title = title;
    childvc.tabBarItem.image = [UIImage imageNamed:image];
    childvc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = TaoColor(123, 123, 123,1);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childvc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childvc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    NBNavigationViewController *nav = [[NBNavigationViewController alloc]initWithRootViewController:childvc];
    [self addChildViewController:nav];

}

- (void)PlusBtnClickWithTabBar:(NBTabBar *)tabBar {
#warning waitting
}
@end
