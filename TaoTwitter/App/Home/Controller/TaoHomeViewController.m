                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   //
//  TaoHomeViewController.m
//  TaoTwitter
//
//  Created by wzt on 15/10/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoHomeViewController.h"
#import "TaoHomeTitleBtn.h"
#import "TaoHomeGroupEditViewController.h"
#import "TaoLoginViewController.h"
#import "NBNavigationViewController.h"
#import "TaoTwitterViewModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "TaoTwitterTableViewCell.h"
#import "TaoTwitterDetailViewController.h"
#import "TaoTwitterDetailHeaderView.h"
#import "TaoTwitterLayout.h"
#import "UIView+TaoSingnal.h"
#define identifer @"statuesCell"

@interface TaoHomeViewController ()
@property (nonatomic, strong) TaoTwitterViewModel *viewModel;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSMutableArray *layouts;


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
    _viewModel = [[TaoTwitterViewModel alloc ] init];
    self.navBarConfig.leftButtonType = TaoNavBarButtonTypeCustomUser;
    self.navBarConfig.rightButtonType = TaoNavBarButtonTypeIconFriend;
    self.navigationItem.titleView = [TaoHomeTitleBtn TitleBtnWithTitle:[[TaoLoginManager standardUserDefaults]currentUserEntity].user.screen_name];
    [TaoNotificationCenter addObserver:self selector:@selector(EditBtnClick) name:TaoHomeTitleMenuEditBtnNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.addPullDown = YES;
    self.addPullUp = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TaoTwitterTableViewCell class] forCellReuseIdentifier:identifer];
    [self loadCacheData];
    if (!self.viewModel.dataSource.count) {
        [self loadNewData];
    }
}

- (void)loadNewData {
    __weak typeof (self) weakSelf = self;
    
    [self.viewModel loadDataWithcompleteBlock:^(NSError *error) {
        if (!error) {
            [weakSelf.layouts removeAllObjects];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf.viewModel.dataSource enumerateObjectsUsingBlock:^(Taostatus  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TaoTwitterLayout *layout = [[TaoTwitterLayout alloc] init];
                    layout.twitter = obj;
                    [weakSelf.layouts addObject:layout];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [weakSelf finfishPullDuwn];
                });
            });
        }else {
            [weakSelf finfishPullDuwn];
        }
    } notModified:nil parameters:nil];
}

- (void)loadCacheData {
    __weak typeof (self) weakSelf = self;
    [self.viewModel loadDataCacheBlock:^(NSError *error) {
        [weakSelf.layouts removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf.viewModel.dataSource enumerateObjectsUsingBlock:^(Taostatus  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TaoTwitterLayout *layout = [[TaoTwitterLayout alloc] init];
                layout.twitter = obj;
                [weakSelf.layouts addObject:layout];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        });

    }];
}

- (void)loadMoreData {
    __weak typeof (self) weakSelf = self;
    [self.viewModel loadMoreBlock:^(NSError *error) {
        if (!error) {
            NSInteger oldCount = weakSelf.layouts.count;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf.viewModel.dataSource enumerateObjectsUsingBlock:^(Taostatus  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx > oldCount - 1) {
                        TaoTwitterLayout *layout = [[TaoTwitterLayout alloc] init];
                        layout.twitter = obj;
                        [weakSelf.layouts addObject:layout];
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView finishPullup];
                });
            });

        }else {
#warning 改进下拉刷新
            [weakSelf.tableView finishPullup];
        }
        
    } parameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#warning 清理
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)layouts {
    if (!_layouts) {
        _layouts = [NSMutableArray array];
    }
    return _layouts;
}

- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _layouts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaoTwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.taoTwitterLayout = _layouts[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaoTwitterLayout *layout = _layouts[indexPath.section];
    
    return layout.twitterCellHeight;
//    return [tableView fd_heightForCellWithIdentifier:identifer cacheByIndexPath:indexPath configuration:^(TaoTwitterTableViewCell *cell) {
//        cell.twitter = _viewModel.dataSource[indexPath.section];
//    }];
}

- (void)EditBtnClick {
    TaoHomeGroupEditViewController *vc = [[TaoHomeGroupEditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navLeftBtnClick:(id)sender {
    NBNavigationViewController *nav = (NBNavigationViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    nav.navigationBar.hidden = NO;
    [nav popViewControllerAnimated:YES];
}

- (void)navRightBtnClick:(id)sender {
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaoTwitterDetailViewController *detil = [[TaoTwitterDetailViewController alloc] init];
    detil.twitter = self.viewModel.dataSource[indexPath.section];
    [self.navigationController pushViewController:detil animated:YES];
    [self.tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}

- (void)handleSignal:(TaoSignal *)signal {
    TaoTwitterDetailViewController *detil = [[TaoTwitterDetailViewController alloc] init];
    detil.twitter = self.viewModel.dataSource[[self.tableView indexPathForCell: signal.dataSource].section];
    
    TaoTwitterDetailHeaderView *headView = [[TaoTwitterDetailHeaderView alloc] initWithFrame:self.view.bounds];
    headView.twitter = detil.twitter;
    NSLayoutConstraint *tempWidthConstraint =
    [NSLayoutConstraint constraintWithItem:headView.contentView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:headView.contentView.width];
    [headView.contentView addConstraint:tempWidthConstraint];
    // Auto layout engine does its math
    CGSize fittingSize = [headView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [headView.contentView removeConstraint:tempWidthConstraint];
    
    detil.tableView.contentOffset = CGPointMake(0, fittingSize.height);
    
    
    
    [self.navigationController pushViewController:detil animated:YES];
}

@end
