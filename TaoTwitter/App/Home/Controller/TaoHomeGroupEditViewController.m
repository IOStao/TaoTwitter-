//
//  TaoHomeGroupEditViewController.m
//  TaoTwitter
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//
#define identifier @"EditCell"

#import "TaoHomeGroupManagerViewController.h"
#import "TaoHomeEditTableViewCell.h"
#import "TaoHomeGroupEditViewController.h"

@interface TaoHomeGroupEditViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView * moveTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation TaoHomeGroupEditViewController

- (void)configureSelf {
    self.navBarConfig.title = @"编辑分组";
    self.navBarConfig.leftButtonType  = TaoNavBarButtonTypeBack;
    self.navBarConfig.rightButtonTitle = @"新建";
    self.navBarConfig.rightButtonType = TaoNavBarButtonTypeInsert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tableview];
    
    
}

- (void)tableview {
    _moveTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _moveTableView.dataSource = self;
    _moveTableView.delegate = self;
    [self.view addSubview:_moveTableView];
    _moveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_moveTableView registerNib:[UINib nibWithNibName:@"TaoHomeEditTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor tao_homeEditHeaderViewColor];
    headerView.size = CGSizeMake(TaoScreenWidth, 0.5);
    _moveTableView.tableHeaderView = headerView;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellImageTap:)];
    longPress.minimumPressDuration = 0.1;
    [_moveTableView addGestureRecognizer:longPress];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaoHomeEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[TaoHomeGroupManagerViewController alloc] init] animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [_moveTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        [_moveTableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)navRightBtnClick:(id)sender {
#warning   自定义 AlearView
}

#pragma mark tap

- (void)cellImageTap:(UILongPressGestureRecognizer *)sender {
    static CGPoint began ;
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;

    CGPoint location = [sender locationInView:_moveTableView];
    NSIndexPath *indexPath = [_moveTableView indexPathForRowAtPoint:location];
    
    TaoHomeEditTableViewCell *cell = [_moveTableView cellForRowAtIndexPath:indexPath];
    CGRect touch = CGRectMake(0, 0, cell.cellImage.width, cell.cellImage.height * self.dataSource.count);
    
    UIGestureRecognizerState state = sender.state;
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath && CGRectContainsPoint(touch, location)) {
                sourceIndexPath = indexPath;
                began = location;
                snapshot = [self customSnapshoFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_moveTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.02, 1.02);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0.0;
                } completion:nil];
            } else {
                //防止begin的点不在图片上；
                began = CGPointMake(-1, -1);
            }
             break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            TaoHomeEditTableViewCell *cell = [_moveTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0;
            if (indexPath && ![indexPath isEqual:sourceIndexPath] && CGRectContainsPoint(touch, began)) {                [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [_moveTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
#warning 有时间优化 用timer
        break;
        }
            
        default: {
            TaoHomeEditTableViewCell *cell = [_moveTableView cellForRowAtIndexPath:sourceIndexPath];
            
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-2.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource ) {
        _dataSource = [NSMutableArray array];
        for (int i = 0; i < 16; i ++) {
            [_dataSource addObject:@(i)];
        }
    }
    return _dataSource;
}
@end
