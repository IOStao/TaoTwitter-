//
//  TaoDetialTwitterViewModel.h
//  TaoTwitter
//
//  Created by wzt on 15/11/5.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    TaoTwitterDetailLoadTypeRetweeted,
    TaoTwitterDetailLoadTypeTypeComment,
    TaoTwitterDetailLoadTypeTypeLike,
} TaoTwitterDetailLoadType;

@interface TaoDetialTwitterViewModel : NSObject
@property(nonatomic, assign) NSInteger maxID;
@property (nonatomic, strong) NSMutableArray *reposts;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *likes;
@property (nonatomic, assign) TaoTwitterDetailLoadType    type;
@property (nonatomic, assign) int      totlaNumber     ;

- (void)loadDataCacheBlock:(void (^)(NSError *error))cacheBlock
             completeBlock:(void (^)(NSError *error))complete
               notModified:(void (^)(NSError *error))notModifiedBlock
                parameters:(id)parameters;

- (void)loadMoreBlock:(void (^)(NSError *error))complete
           parameters:(id)parameter;

- (void)loadDataCacheBlock:(void (^)(NSError *error))cacheBlock;
@end
