//
//  TaoTwitterViewModel.h
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoTwitterViewModel : NSObject
@property(nonatomic, assign) NSInteger maxID;
@property (nonatomic, strong) Taostatus *status;
@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)loadDataCacheBlock:(void (^)(NSError *error))cacheBlock
             completeBlock:(void (^)(NSError *error))complete
               notModified:(void (^)(NSError *error))notModifiedBlock
                parameters:(id)parameter;

- (void)loadMoreBlock:(void (^)(NSError *error))complete
           parameters:(id)parameter;

- (void)loadDataCacheBlock:(void (^)(NSError *error))cacheBlock;

@end
