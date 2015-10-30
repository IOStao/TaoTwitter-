//
//  TaoLoginViewController.m
//  TaoTwitter
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoLoginViewController.h"
#import "TaoAccountViewModel.h"
#import "TaoAccountTableViewCell.h"
#import "NBTabBarViewController.h"
#import "TaoAccountHeaderView.h"

#define identifier @"AccountCell"
#define lineHeight 0.5


@interface TaoLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *accountTableView;
@property (nonatomic, strong) TaoAccountViewModel *viewModel;
@property(nonatomic, assign) BOOL isLoad;
@end

@implementation TaoLoginViewController



- (void)configureSelf {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(navLeftBtnClick:) type:TaoNavBarButtonTypeInsert title:@"编辑"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(navRightBtnClick:) type:TaoNavBarButtonTypeInsert title:@"设置"];
    self.navigationItem.title = @"账户管理";
    [_accountTableView setEditing:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableview];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_viewModel.accounts.count && !_isLoad) {
            [self AccountAdd];
        }
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

#pragma  mark private
- (void)tableview {
    _viewModel = [[TaoAccountViewModel alloc] init];
    _accountTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain
                         ];
    _accountTableView.delegate = self;
    _accountTableView.dataSource = self;
    _accountTableView.backgroundColor = [UIColor tao_homeEditCellColor];
    _accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_accountTableView];
    
    _accountTableView.tableHeaderView = [TaoAccountHeaderView taoAccountHeaderView];
    [_accountTableView registerNib:[UINib nibWithNibName:@"TaoAccountTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
}

- (void)navLeftBtnClick:(id)sender {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(configureSelf) type:TaoNavBarButtonTypeInsert title:@"完成"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(AccountAdd) type:TaoNavBarButtonTypeInsert title:@"添加"];
    [_accountTableView setEditing:YES];
}

- (void)navRightBtnClick:(id)sender {
#warning 系统设置
}

- (void)AccountAdd {
    _isLoad = YES;
    [self.viewModel loadData];
    __weak typeof(self)weakSelf = self;
    _viewModel.myBlock = ^{
        [weakSelf.accountTableView reloadData];
    };
}

#pragma mark tableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _accountTableView.tableHeaderView.hidden = self.viewModel.accounts.count?NO:YES;
    return self.viewModel.accounts.count;
}

#pragma mark tableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TaoNotificationCenter postNotificationName:TaoAccountLogin object:nil userInfo:[NSDictionary dictionaryWithObject:@(indexPath.section) forKey:@"uid"]];
    
    NBTabBarViewController *vc = [[NBTabBarViewController alloc] init];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaoAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.account = (TaoAccountItem *)[_viewModel.accounts objectAtIndex:indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.showsReorderControl = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor tao_AccountCellColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return lineHeight;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_viewModel removeAccountAtindex:indexPath.section];
        [_accountTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [_viewModel exchangeObjectAtIndex:sourceIndexPath.section withObjectAtIndex:destinationIndexPath.section];
    [_accountTableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


@end
