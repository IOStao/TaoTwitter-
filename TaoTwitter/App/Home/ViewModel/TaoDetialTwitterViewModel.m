//
//  TaoDetialTwitterViewModel.m
//  TaoTwitter
//
//  Created by wzt on 15/11/5.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoDetialTwitterViewModel.h"
#import "TaoNetManager.h"

@interface TaoDetialTwitterViewModel ()
@property(nonatomic, assign) NSInteger since_id;

@end

@implementation TaoDetialTwitterViewModel

- (NSMutableArray *)comments {
    if(!_comments){
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (NSMutableArray *)reposts {
    if (!_reposts) {
        _reposts = [NSMutableArray array];
    }
    return _reposts;
}

- (NSMutableArray *)likes {
    if (!_likes) {
        _likes = [NSMutableArray array];
    }
    return _likes;
}

- (NSInteger)since_id {
    if (!_since_id) {
        _since_id = 0;
    }
    return _since_id;
}

- (void)loadDataCacheBlock:(void (^)(NSError *))cacheBlock completeBlock:(void (^)(NSError *))complete notModified:(void (^)(NSError *))notModifiedBlock parameters:(id)parameters  {
    

    NSString *url = nil;
    switch (self.type) {
        case TaoTwitterDetailLoadTypeTypeComment:{
            url = @"comments/show.json";
            [[TaoNetManager sharedInstance]requestWithPath:url parameters:parameters completion:^(NSError *error, Taocomments *resultObject) {
                self.comments = [resultObject.comments mutableCopy];
                self.totlaNumber = resultObject.total_number;
                complete(error);
            }];}
            break;
            
        case TaoTwitterDetailLoadTypeRetweeted:{
            url = @"statuses/repost_timeline.json";
            [[TaoNetManager sharedInstance]requestWithPath:url parameters:parameters completion:^(NSError *error, Taoreposts *resultObject) {
                self.reposts = [resultObject.reposts mutableCopy];
                self.totlaNumber = resultObject.total_number;
                complete(error);
            }];}
            break;
            
        case TaoTwitterDetailLoadTypeTypeLike:
            [[TaoNetManager sharedInstance]requestWithPath:url parameters:parameters completion:^(NSError *error, id resultObject) {
                complete(error);
            }];
            break;
     }
}

- (void)loadMoreBlock:(void (^)(NSError *))complete parameters:(id)parameter {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameter];


    NSString *url = nil;
    switch (self.type) {
        case TaoTwitterDetailLoadTypeTypeComment:{
            url = @"comments/show.json";
            dict[@"max_id"] = @(self.maxID);
            
            [[TaoNetManager sharedInstance]requestWithPath:url parameters:dict completion:^(NSError *error, Taocomments *resultObject) {
             [self.comments addObjectsFromArray:resultObject.comments];
                Taocomment *md = [self.comments lastObject];
                self.maxID = md.idstr.integerValue - 1;
                complete(error);
            }];}
            break;
            
        case TaoTwitterDetailLoadTypeRetweeted:{
            url = @"statuses/repost_timeline.json";
            dict[@"max_id"] = @(self.maxID);
            
            [[TaoNetManager sharedInstance]requestWithPath:url parameters:parameter completion:^(NSError *error, Taoreposts *resultObject) {
                [self.reposts addObjectsFromArray :resultObject.reposts ];
                Taostatus *md = [self.reposts lastObject];
                self.maxID = md.idstr.integerValue - 1;

                complete(error);
            }];}
            break;
            
        case TaoTwitterDetailLoadTypeTypeLike:
            
//            Taostatus *md = [self.dataSource lastObject];
//            self.maxID = md.idstr.integerValue - 1;
            [[TaoNetManager sharedInstance]requestWithPath:url parameters:parameter completion:^(NSError *error, id resultObject) {
                complete(error);
            }];
            break;
    }
}
@end
