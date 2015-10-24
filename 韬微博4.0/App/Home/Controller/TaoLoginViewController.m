//
//  TaoLoginViewController.m
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoLoginViewController.h"
#import "TaoAccountViewModel.h"
#import "TaoAccountTableViewCell.h"
#define identifier @"AccountCell"

@interface TaoLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *accountTableView;
@property (nonatomic, strong) TaoAccountViewModel *viewModel;
@property(nonatomic, assign) BOOL isLoad;
@end

@implementation TaoLoginViewController

- (void)configureSelf {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(navLeftBtnClick:) type:TaoNavBarButtonTypeInsert title:@"编辑"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(navRightBtnClick:) type:TaoNavBarButtonTypeInsert title:@"设置"];
    [_accountTableView setEditing:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_viewModel.accounts.count && !_isLoad) {
            [self AccountAdd];
        }
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableview {
    _viewModel = [[TaoAccountViewModel alloc] init];
    _accountTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain
                         ];
    _accountTableView.delegate = self;
    _accountTableView.dataSource = self;
    _accountTableView.backgroundColor = [UIColor tao_homeEditCellColor];
    _accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_accountTableView];
    [_accountTableView setContentInset:UIEdgeInsetsMake(15, 0, 0, 0)];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor tao_AccountCellColor];
    headerView.size = CGSizeMake(TaoScreenWidth, 0.5);
    _accountTableView.tableFooterView = headerView;
    
    [_accountTableView registerNib:[UINib nibWithNibName:@"TaoAccountTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
}

- (void)navLeftBtnClick:(id)sender {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(configureSelf) type:TaoNavBarButtonTypeInsert title:@"完成"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(AccountAdd) type:TaoNavBarButtonTypeInsert title:@"添加"];
    [_accountTableView setEditing:YES];
}

- (void)AccountAdd {
    _isLoad = YES;
    [self.viewModel loadData];
    __weak typeof(self)weakSelf = self;
    _viewModel.myBlock = ^{
        [weakSelf.accountTableView reloadData];
    };
}

- (void)navRightBtnClick:(id)sender {
#warning 系统设置
}

#pragma mark tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    _accountTableView.tableFooterView.hidden = self.viewModel.accounts.count?NO:YES;

    return self.viewModel.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    TaoAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (_viewModel.user) {
        cell.user = _viewModel.user;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.showsReorderControl = YES;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor tao_AccountCellColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
#warning 整理
        TaoAccountItems *items = [TaoAccountTool account];
        [items.items removeObjectAtIndex:indexPath.row];
        [self.viewModel.accounts removeObjectAtIndex:indexPath.row];
        [TaoAccountTool saveAccount:items];
        [_accountTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
#warning 整理
    [self.viewModel.accounts exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
