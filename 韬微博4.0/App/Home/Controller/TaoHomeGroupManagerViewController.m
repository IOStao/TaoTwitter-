//
//  TaoHomeGroupManagerViewController.m
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoHomeGroupManagerViewController.h"

@interface TaoHomeGroupManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *searchBackGroundView;
@property (weak, nonatomic) IBOutlet UITableView *groupManager;
@property (weak, nonatomic) IBOutlet UICollectionView *PeopleManager;

@end

@implementation TaoHomeGroupManagerViewController
- (void)configureSelf {
    self.navBarConfig.rightButtonTitle = @"更新";
    self.navBarConfig.rightButtonType = TaoNavBarButtonTypeInsert;
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"TaoHomeGroupManagerViewController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    self.searchView.layer.cornerRadius = 5;
    self.searchBackGroundView.backgroundColor = [UIColor tao_homeEditHeaderViewColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#warning waitting group and item
#warning searchbar  jump
@end
