//
//  UIView+TaoSingnal.h
//  韬微博4.0
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const TaoSignalKeyId;

@interface TaoSignal : NSObject

///数据源格式
@property(strong, nonatomic) NSDictionary *parmeter;

@property(strong, nonatomic) id dataSource;
///传递数据源终点 默认是UIViewController
@property(strong,nonatomic) Class target;
///signal源头
@property(strong, nonatomic) UIView *source;
///用于区分多个signal源
@property(assign,nonatomic) NSInteger sourceTag;

+ (TaoSignal *)signalWithDataSource:(id)dataSource signalTag:(NSInteger)sourceTag;

+ (TaoSignal *)signalWithDataSource:(id)dataSource signalTag:(NSInteger)sourceTag target:(Class)clz;

+ (TaoSignal *)signalWithDataSource:(id)dataSource;

@end


@interface UIView (TaoSingnal)

- (void)sendSignal:(TaoSignal *)signal;

@end
