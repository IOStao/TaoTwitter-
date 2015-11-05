//
//  TaoTwitterDetailViewController.m
//  TaoTwitter
//
//  Created by wzt on 15/11/2.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterDetailViewController.h"
#import "TaoTwitterDetailHeaderView.h"
#import "TaoDetialTwitterSctionHeaderView.h"

@interface TaoTwitterDetailViewController ()<TaoDetialTwitterSctionHeaderViewDelegate>

@end

@implementation TaoTwitterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTbaleView];
    [self configureHead];
}

- (void)configureSelf {
    self.navBarConfig.title = @"微博正文";
    self.navBarConfig.leftButtonType = TaoNavBarButtonTypeBack;
    self.navBarConfig.rightButtonType = TaoNavBarButtonTypeIconShare;
}

- (void)configureHead {
   TaoTwitterDetailHeaderView *headView = [[TaoTwitterDetailHeaderView alloc] initWithFrame:self.view.bounds];
    headView.twitter = self.twitter;
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
    headView.height = fittingSize.height;
    [self.tableView setTableHeaderView:headView];
 }

- (void)configureTbaleView {
    self.addPullDown = YES;
    self.addPullUp = YES;
    self.tableView.infiniteScrollingView.enabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navRightBtnClick:(id)sender {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TaoDetialTwitterSctionHeaderView *view = [[TaoDetialTwitterSctionHeaderView alloc] init];
    view.twitter = self.twitter;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     TaoDetialTwitterSctionHeaderView *view = [[TaoDetialTwitterSctionHeaderView alloc] init];
    view.twitter = self.twitter;
    view.delegate = self;
    return [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc ]init];
    cell.textLabel.text = @"sds0";
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)slkdfjlksjdflksd{
    
}

@end
