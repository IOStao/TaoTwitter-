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
#import "TaoDetialTwitterViewModel.h"
#import "TaoDetialTwitterCommentTableViewCell.h"
#import "TaoDetialTwitterRepostTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

#define CommentdIdentifier  @"CommentdIdentifier"
#define RepostIdentifier    @"RepostIdentifier"
#define LikeIdentifier      @"LikeIdentifier"

@interface TaoTwitterDetailViewController ()<TaoDetialTwitterSctionHeaderViewDelegate>
@property(nonatomic, strong) TaoDetialTwitterSctionHeaderView *headerView;
@property (nonatomic, strong) TaoDetialTwitterViewModel *viewModel;
@end

@implementation TaoTwitterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTbaleView];
    [self configureHead];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)configureSelf {
    _viewModel = [[TaoDetialTwitterViewModel alloc] init];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TaoDetialTwitterCommentTableViewCell class] forCellReuseIdentifier:CommentdIdentifier];
    [self.tableView registerClass:[TaoDetialTwitterRepostTableViewCell class] forCellReuseIdentifier:RepostIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navRightBtnClick:(id)sender {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows;
    if (self.headerView.type == TaoTwitterDetailHeaderViewTypeComment) {
        rows =  _viewModel.comments.count;
    }else if (self.headerView.type == TaoTwitterDetailHeaderViewTypeRetweeted) {
        rows = _viewModel.reposts.count;
    }else {
        rows =  50;
    }
//    self.tableView.infiniteScrollingView.enabled = rows>20?YES:NO;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.headerView.type == TaoTwitterDetailHeaderViewTypeComment) {
        if (indexPath.row < _viewModel.comments.count) {
            TaoDetialTwitterCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentdIdentifier];
            cell.comment = _viewModel.comments[indexPath.row];
            return cell;
        }else {
            return [[UITableViewCell alloc] init];
        }
        
    }else if (self.headerView.type == TaoTwitterDetailHeaderViewTypeRetweeted) {
        if (indexPath.row < _viewModel.reposts.count) {
            TaoDetialTwitterRepostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RepostIdentifier];
            cell.twitter = _viewModel.reposts[indexPath.row];
            return cell;
        }else {
            return [[UITableViewCell alloc] init];
        }
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.headerView.type == TaoTwitterDetailHeaderViewTypeComment) {
        if (indexPath.row < self.viewModel.comments.count) {
        return [tableView fd_heightForCellWithIdentifier:CommentdIdentifier cacheByIndexPath:indexPath configuration:^(TaoDetialTwitterCommentTableViewCell *cell) {
            cell.comment = _viewModel.comments[indexPath.row];
        }];}else {
            return 50;
        }
    }else if (self.headerView.type == TaoTwitterDetailHeaderViewTypeRetweeted) {
        if (indexPath.row < self.viewModel.reposts.count) {
            return [tableView fd_heightForCellWithIdentifier:CommentdIdentifier cacheByIndexPath:indexPath configuration:^(TaoDetialTwitterRepostTableViewCell *cell) {
                cell.twitter = _viewModel.reposts[indexPath.row];
            }];
        }else {
            return 50;
        }
    }else {
        return 50;
    }

}

- (TaoDetialTwitterSctionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[TaoDetialTwitterSctionHeaderView alloc] init];
        _headerView.twitter = self.twitter;
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)TaoDetialTwitterHeaderView:(TaoDetialTwitterSctionHeaderView *)headerView btnClick:(TaoTwitterDetailHeaderViewType)btnType {
    [self.tableView reloadData];
    switch (btnType) {
        case TaoTwitterDetailHeaderViewTypeComment:
            self.viewModel.type = TaoTwitterDetailLoadTypeTypeComment;
            break;
            
        case TaoTwitterDetailHeaderViewTypeRetweeted:
            self.viewModel.type = TaoTwitterDetailLoadTypeRetweeted;
            break;
            
        case TaoTwitterDetailHeaderViewTypeLike:
            self.viewModel.type = TaoTwitterDetailLoadTypeTypeLike;
            break;
        default: {
            break;
        }
    }
    [self loadNewData];
}

- (void)loadNewData {
    __weak typeof(self)weakSelf = self;
     NSDictionary *dict = [NSDictionary dictionaryWithObject:self.twitter.idstr forKey:@"id"];
    [self.viewModel loadDataCacheBlock:^(NSError *error) {
        if (!error) {
            [weakSelf.tableView reloadData];
        }
        [weakSelf finfishPullDuwn];
    } completeBlock:^(NSError *error) {
        if (!error) {
            
            switch (weakSelf.viewModel.type) {
                case TaoTwitterDetailLoadTypeRetweeted:
                    weakSelf.twitter.reposts_count = weakSelf.viewModel.totlaNumber;
                    weakSelf.headerView.twitter = weakSelf.twitter;
                    break;
                    
                case TaoTwitterDetailLoadTypeTypeComment:
                    weakSelf.twitter.comments_count = weakSelf.viewModel.totlaNumber;
                    weakSelf.headerView.twitter = weakSelf.twitter;
                    break;
                default:
                    break;
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf finfishPullDuwn];
    } notModified:^(NSError *error) {
        
    } parameters:dict];
}

- (void)loadMoreData {
    __weak typeof(self)weakSelf = self;
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.twitter.idstr forKey:@"id"];
    [self.viewModel loadMoreBlock:^(NSError *error) {
        if (!error) {
            [weakSelf.tableView reloadData];
            weakSelf.tableView.infiniteScrollingView.enabled = weakSelf.viewModel.maxID;
        }
        [weakSelf.tableView finishPullup];
    } parameters:dict];
}

@end
