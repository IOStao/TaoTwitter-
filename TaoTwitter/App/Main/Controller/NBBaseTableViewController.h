//
//  NBBaseTableViewController.h
//  TaoTwitter
//
//  Created by wzt on 15/10/31.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBBaseTableViewController : UITableViewController<TaoNavigationBarItemHandler>

@property (nonatomic, assign) BOOL                      addPullDown;
@property (nonatomic, assign) BOOL                      addPullUp;

- (void)configureSelf;
- (void)loadNewData;
- (void)loadCacheData;
- (void)loadMoreData;
- (void)finfishPullDuwn;
@end
