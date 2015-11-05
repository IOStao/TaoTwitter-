//
//  TaoTwitterViewModel.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterViewModel.h"
#import "TaoNetManager.h"

@interface TaoTwitterViewModel ()
@property(nonatomic, assign) NSInteger since_id;

@end

@implementation TaoTwitterViewModel

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSInteger)since_id {
    if (!_since_id) {
        _since_id = 0;
    }
    return _since_id;
}

- (void)loadDataCacheBlock:(void (^)(NSError *))cacheBlock completeBlock:(void (^)(NSError *))complete notModified:(void (^)(NSError *))notModifiedBlock parameters:(id)parameter {
    Taostatus *sd = [self.dataSource firstObject];
    if (sd) {
        self.since_id = sd.idstr.integerValue - 1;
    }else {
        self.since_id = 0;
    }
    

    [[TaoNetManager sharedInstance] requestWithPath:@"statuses/friends_timeline.json" parameters:[NSDictionary dictionaryWithObject:@(self.since_id) forKey:@"since_id"] cacheBlock:^(NSError *error, Taostatuses *resultObject) {
        if (!error) {
            self.dataSource = [resultObject.statuses mutableCopy];
            cacheBlock(error);
        }
    } completion:^(NSError *error, Taostatuses *resultObject) {
        if (!error) {
            NSRange range = NSMakeRange(0, resultObject.statuses.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.dataSource insertObjects:resultObject.statuses atIndexes:set];
        }
        complete(error);
    }];
}

- (void)loadDataCacheBlock:(void (^)(NSError *))cacheBlock {
    [[TaoNetManager sharedInstance]requestWithPath:@"statuses/friends_timeline.json" parameters:[NSDictionary dictionary] cacheBlock:^(NSError *error, Taostatuses *resultObject) {
        self.dataSource = [resultObject.statuses mutableCopy];
        cacheBlock(error);
    }];
    
}

- (void)loadMoreBlock:(void (^)(NSError *))complete parameters:(id)parameter {
    Taostatus *md = [self.dataSource lastObject];
    self.maxID = md.idstr.integerValue - 1;
   [[TaoNetManager sharedInstance] requestWithPath:@"statuses/friends_timeline.json" parameters:[NSDictionary dictionaryWithObject:@(self.maxID) forKey:@"max_id"] completion:^(NSError *error, Taostatuses *resultObject) {
       if (!error) {
           [self.dataSource addObjectsFromArray:resultObject.statuses];
           
       }else {
#warning 无网络
       }
       complete(error);
    }];
}
@end
