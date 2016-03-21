//
//  UIView+TaoSingnal.m
//  TaoTwitter
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "UIView+TaoSingnal.h"

NSString * const TaoSignalKeyId = @"TaoSignalKeyId";

static NSInteger  const kTaoSignalTag = 0;

@implementation TaoSignal

+ (TaoSignal *)signalWithDataSource:(id)dataSource
{
    return [[TaoSignal alloc]initSignalWithDataSource:dataSource signalTag:kTaoSignalTag target:nil];
}

+ (TaoSignal *)signalWithDataSource:(id)dataSource signalTag:(NSInteger)sourceTag
{
    return [[TaoSignal alloc] initSignalWithDataSource:dataSource signalTag:sourceTag target:nil];
}

+ (TaoSignal *)signalWithDataSource:(id)dataSource signalTag:(NSInteger)sourceTag target:(Class)clz
{
    return [[TaoSignal alloc] initSignalWithDataSource:dataSource signalTag:sourceTag target:clz];
}

- (instancetype)initSignalWithDataSource:(id)dataSource signalTag:(NSInteger)sourceTag target:(Class)clz
{
    self = [super init];
    if (self)
    {
        self.dataSource = dataSource;
        self.sourceTag = sourceTag;
        self.target = clz;
    }
    return self;
}
@end

@implementation UIView (TaoSingnal)

- (void)sendSignal:(TaoSignal *)signal
{
    Class targetClass = [UIViewController class];
    
    if (signal.target)
    {
        targetClass = signal.target;
    }
    
    UIResponder *responder = self;
    
    while (![responder isKindOfClass:targetClass])
    {
        responder = [responder nextResponder];
//        NSLog(@"responder = %@",responder);
        if (!responder)
        {
            break;
        }
    }
    
    if ([responder isKindOfClass:targetClass])
    {
        
        SEL sel = NSSelectorFromString(@"handleSignal:");
        
        UIViewController *vc  = (UIViewController *)responder;
        
        if ([vc respondsToSelector:sel])
        {
            void (*imp)(id, SEL,TaoSignal *) = (void(*)(id, SEL,TaoSignal *))[vc methodForSelector: sel];
            imp(vc,sel,signal);
        }
        
    }
    
}

@end
