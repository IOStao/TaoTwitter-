//
//  TaoTwitterTableViewCell.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoStatusPhotosView.h"
#import "TaoTwitterTableViewCell.h"
#import "TaoTwitterCellBottomBar.h"
#import "TaoTwitterStatusView.h"
#import "TaoTwitterRStatusView.h"
#import "TaoTwitterLayout.h"

@interface TaoTwitterTableViewCell ()
@property (nonatomic, strong)  TaoTwitterStatusView *statusView;
@property (nonatomic, strong)  TaoTwitterRStatusView *rStatusView;
@property (nonatomic, strong)  TaoTwitterCellBottomBar *bar;
@property (nonatomic, strong)  UIView *barLine;
@end

@implementation TaoTwitterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.statusView = [[TaoTwitterStatusView alloc]init];
        [self.contentView addSubview:self.statusView];
        
        self.rStatusView = [[TaoTwitterRStatusView alloc] init];
        [self.contentView addSubview:self.rStatusView];
        
        self.bar = [[TaoTwitterCellBottomBar alloc] init];
        [self.contentView addSubview:self.bar];
        
    }
    return self;
}

- (void)setTaoTwitterLayout:(TaoTwitterLayout *)taoTwitterLayout {
    _taoTwitterLayout = taoTwitterLayout;
    
    self.statusView.frame = taoTwitterLayout.statuesViewFrame;
    self.statusView.statuesViewLayout = taoTwitterLayout.statuesViewLayout;
    
    if (!CGRectEqualToRect(taoTwitterLayout.rStatuesViewFrame, CGRectZero)) {
        self.rStatusView.hidden = NO;
        self.rStatusView.frame = taoTwitterLayout.rStatuesViewFrame;
        self.rStatusView.rStatuesViewLayout = taoTwitterLayout.rStatuesViewLayout;
    }else {
        self.rStatusView.hidden = YES;
    }
    self.bar.frame = taoTwitterLayout.toolBarFrame;
    self.bar.cellBarLayout = taoTwitterLayout.barLayout;
}

@end

//#import "TaoStatusPhotosView.h"
//#import "TaoTwitterTableViewCell.h"
//#import <Masonry/Masonry.h>
//#import "TaoTwitterCellBottomBar.h"
//#import "TaoTwitterStatusView.h"
//#import "TaoTwitterRStatusView.h"
//
//@interface TaoTwitterTableViewCell ()
//@property (nonatomic, strong)  TaoTwitterStatusView *statusView;
//@property (nonatomic, strong)  TaoTwitterRStatusView *rStatusView;
//@property (nonatomic, strong)  TaoTwitterCellBottomBar *bar;
//@property (nonatomic, strong)  UIView *barLine;
//@end
//
//@implementation TaoTwitterTableViewCell
//
//- (TaoTwitterStatusView *)statusView {
//    if (!_statusView) {
//        _statusView = [[TaoTwitterStatusView alloc]init];
//        [self.contentView addSubview:_statusView];
//        [_statusView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(@(0));
//        }];
//    }
//    return _statusView;
//}
//
//- (TaoTwitterRStatusView *)rStatusView {
//    if (!_rStatusView) {
//        _rStatusView = [[TaoTwitterRStatusView alloc] init];
//        [self.contentView addSubview:_rStatusView];
//    }
//    return _rStatusView;
//}
//
//- (TaoTwitterCellBottomBar *)bar {
//    if (!_bar) {
//        _bar = [[TaoTwitterCellBottomBar alloc] init];
//        [self.contentView addSubview:_bar];
//        [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.rStatusView.mas_bottom).offset(10);
//            make.left.right.equalTo(@(0));
//            make.height.equalTo(@(35));
//        }];
//    }
//    return _bar;
//}
//
//- (UIView *)barLine {
//    if (!_barLine) {
//        _barLine = [[UIView alloc] init];
//        _barLine.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:_barLine];
//        [_barLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.left.bottom.equalTo(@(0));
//            make.top.equalTo(self.bar.mas_bottom);
//        }];
//    }
//    return _barLine;
//}
//
//- (void)setTwitter:(Taostatus *)twitter {
//    _twitter = twitter;
//    
//    [self statusView];
//    [self rStatusView];
//    [self bar];
//    [self barLine];
//    self.statusView.twitter = twitter;
//   
//    if (twitter.retweeted_status) {
//        self.rStatusView.hidden = NO;
//        self.rStatusView.twitter = twitter.retweeted_status;
//        [_rStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.statusView.mas_bottom).offset(10);
//            make.left.right.equalTo(@(0));
//
//        }];
//        } else {
//        self.rStatusView.hidden = YES;
//        [_rStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(0));
//            make.top.equalTo(self.statusView.mas_bottom).offset(0);
//        }];
//    }
//    
//    self.bar.twitter = twitter;
//    
//}
//@end
