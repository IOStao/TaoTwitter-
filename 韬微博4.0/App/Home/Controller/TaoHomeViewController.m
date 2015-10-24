//
//  TaoHomeViewController.m
//  韬微博4.0
//
//  Created by wzt on 15/10/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoHomeViewController.h"
#import "TaoHomeTitleBtn.h"
#import "TaoHomeGroupEditViewController.h"

@interface TaoHomeViewController ()

@end

@implementation TaoHomeViewController

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"TaoHomeViewController"];
            }
    return self;
}

- (void)configureSelf {
    self.navBarConfig.rightButtonType = TaoNavBarButtonTypeIconRadar;
    self.navBarConfig.leftButtonType = TaoNavBarButtonTypeIconFriend;
    self.navigationItem.titleView = [TaoHomeTitleBtn TitleBtnWithTitle:@"首页"];
    [TaoNotificationCenter addObserver:self selector:@selector(EditBtnClick) name:TaoHomeTitleMenuEditBtnNotification object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)EditBtnClick {
    TaoHomeGroupEditViewController *vc = [[TaoHomeGroupEditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)navLeftBtnClick:(id)sender {
    NSLog(@"sdsdsds");
}

- (void)navRightBtnClick:(id)sender {
    NSLog(@"SfddsfD");
}
@end
