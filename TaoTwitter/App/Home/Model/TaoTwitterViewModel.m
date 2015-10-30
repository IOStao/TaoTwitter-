//
//  TaoTwitterViewModel.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterViewModel.h"
#import "TaoHTTPTool.h"
#import "MJExtension.h"

@implementation TaoTwitterViewModel

- (void)loaddata {
    __block TaoTwitteres *twitters = nil;
    [[TaoHTTPTool sharedInstance]get:@"statuses/friends_timeline.json" params:[NSDictionary dictionary] success:^(id json) {
        twitters = [[TaoTwitteres alloc] initWithDictionary:json error:nil];
//        self.dataSource  = [TaoTwitter objectArrayWithKeyValuesArray:json[@"statuses"]];
        self.dataSource = [twitters.statuses mutableCopy];
        
    } failure:^(NSError *error) {
        TaoLog(@"请求失败-%@", error);
    }];
}

//- (void)loadDataCacheBlock:(void (^)(NSError *error))cacheBlock
//             completeBlock:(void (^)(NSError *error))complete
//               notModified:(void (^)(NSError *error))notModified
//                parameters:(id)parameter
//{
//       __weak typeof (self) weakSelf = self;
//    
//    [[TaoNetManager sharedInstance]requestWithPath:@"statuses/friends_timeline.json" parameters:nil completion:^(NSError *error, id resultObject) {
//         weakSelf.dataSource  =  [resultObject mutableCopy];
//    }];
//
//}
@end
