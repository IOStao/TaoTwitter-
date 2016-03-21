//
//  TaoComposeEmotionPlistTool.m
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeEmotionPlistTool.h"
#import "TaoUserDefults.h"
#import "TaoComposeEmotionModel.h"

#define maxPageEmotionCount 21

NSString *const recentEmotionsKey = @"recentEmotionsKey";

@interface TaoComposeEmotionPlistTool () {
    
}
@property (nonatomic, strong) NSMutableArray *recentEmotions;
@property (nonatomic, strong) NSArray *emojiEmotions;
@property (nonatomic, strong) NSArray *defaultEmotions;
@property (nonatomic, strong) NSArray *lxhEmotions;
@end

@implementation TaoComposeEmotionPlistTool
static TaoComposeEmotionPlistTool *_TaoComposeEmotionPlistTool = nil;

+ (id)standard{
    static dispatch_once_t predUserDefaults;
    dispatch_once(&predUserDefaults, ^{
        _TaoComposeEmotionPlistTool=[[TaoComposeEmotionPlistTool alloc] init];
    });
    return _TaoComposeEmotionPlistTool;
}

- (TaoComposeEmotionModel *)emotionWithChs:(NSString *)chs
{
    NSArray *defaults = self.defaultEmotions;
    for (TaoComposeEmotionModel *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    NSArray *lxhs = self.lxhEmotions;
    for (TaoComposeEmotionModel *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    return nil;
}


- (void)addRecentEmotion:(TaoComposeEmotionModel *)emotion {
    [_recentEmotions removeObject:emotion];
    
    [_recentEmotions insertObject:emotion atIndex:0];
    
    TaoComposeEmotionModel *model = [[TaoComposeEmotionModel alloc] init];
    model.png = model.code = nil;
    model.emotionDelete = YES;
    [_recentEmotions insertObject:model atIndex:maxPageEmotionCount - 1];
    
    if (_recentEmotions.count > maxPageEmotionCount) {
        NSRange rang ;
        rang.location = maxPageEmotionCount;
        rang.length  = _recentEmotions.count - maxPageEmotionCount;
        [_recentEmotions removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rang]];
    }
    
    // 将所有的表情数据写入沙盒
    [[TaoUserDefults standardUserDefaults]setObject:_recentEmotions forKey:recentEmotionsKey];
}


- (NSArray *)recentEmotions {
    _recentEmotions = [[TaoUserDefults standardUserDefaults ]objectForKey:recentEmotionsKey];
    if (!_recentEmotions) {
        _recentEmotions = [NSMutableArray array];
        _recentEmotions = [[self valueAndObjectChangeWithObjectArray:_recentEmotions] mutableCopy];
    }
    return _recentEmotions;
}

- (NSArray *)emojiEmotions {
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emojiinfo.plist" ofType:nil];
        _emojiEmotions = [self valueAndObjectChangeWithNormolArray:[NSMutableArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}

- (NSArray *)defaultEmotions {
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultinfo.plist" ofType:nil];
        _defaultEmotions = [self valueAndObjectChangeWithNormolArray:[NSMutableArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}

- (NSArray *)lxhEmotions {
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lxhinfo.plist" ofType:nil];
        _lxhEmotions = [self valueAndObjectChangeWithNormolArray:[NSMutableArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}

- (NSArray *)valueAndObjectChangeWithNormolArray:(NSMutableArray *)orginalArray {
    double totalCount = (orginalArray.count + ceil((float)orginalArray.count /(maxPageEmotionCount))) > ceil((float)orginalArray.count /(maxPageEmotionCount)) * (maxPageEmotionCount)?(ceil((float)orginalArray.count /(maxPageEmotionCount))+1) * (maxPageEmotionCount):ceil((float)orginalArray.count /(maxPageEmotionCount)) * (maxPageEmotionCount);
     ;
    NSInteger dis = totalCount - orginalArray.count;
    __block NSMutableArray *newArray = [NSMutableArray array];
    __block NSMutableArray *modelArray = [NSMutableArray array];
    
    if (dis > 0 ) {
        for (int i = 1; i <= dis; i ++) {
            [orginalArray addObject:@{@"isNotEmotion":@"YES"}];
        }
    }
    
    [orginalArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaoComposeEmotionModel *model = [[TaoComposeEmotionModel alloc] initWithDictionary:obj error:nil];
        [modelArray addObject:model];
        if ((idx +1)  % (maxPageEmotionCount) == 0) {
            TaoComposeEmotionModel *model = [[TaoComposeEmotionModel alloc] init];
            model.emotionDelete = YES;
            [modelArray insertObject:model atIndex:idx];
        }
    }];

    [modelArray enumerateObjectsUsingBlock:^(TaoComposeEmotionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [newArray addObject:obj];
        if (newArray.count ==  orginalArray.count) {
            *stop = YES;
        }
    }];
    return newArray;
}

- (NSArray *)valueAndObjectChangeWithObjectArray:(NSMutableArray *)orginalArray {
    double totalCount = orginalArray.count? ceil((float)orginalArray.count /(maxPageEmotionCount)) * (maxPageEmotionCount) :maxPageEmotionCount;
    NSInteger dis = totalCount - orginalArray.count;
    __block NSMutableArray *newArray = [NSMutableArray array];
    
    if (dis > 0 ) {
        for (int i = 0; i < dis; i ++) {
            TaoComposeEmotionModel *model = [[TaoComposeEmotionModel alloc] init];
            model.isNotEmotion = YES;
            [orginalArray addObject:model];
        }
    }
    [orginalArray enumerateObjectsUsingBlock:^(TaoComposeEmotionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((idx + 1) % (maxPageEmotionCount) == 0) {
            obj.png = obj.code = nil;
            obj.emotionDelete = YES;
        }
        [newArray addObject:obj];
        if (newArray.count == maxPageEmotionCount ) {
            *stop = YES;
        }
    }];
    return newArray;
}
@end
