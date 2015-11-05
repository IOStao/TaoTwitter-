//
//  NSObject+NSObject_Singleton.m
//  Zhidao
//
//  Created by aggie on 4/16/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import "NSObject+Singleton.h"

@implementation NSObject (Singleton)

NSMutableDictionary *_instanceDict;

//命名
+(instancetype)sharedInstance_ks{
    id _instance;
    @synchronized(self)
    {
        if (_instanceDict == nil) {
            _instanceDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        }
        
        NSString *_className = NSStringFromClass([self class]);
        _instance = _instanceDict[_className];
       
        if (_instance == nil) {
            _instance = [[self.class alloc] init];
            [_instanceDict setValue:_instance forKey:_className];
        }
        return _instance;
    }
}

+ (void)destorySharedInstance_ks
{
    if (_instanceDict == nil) {
        return;
    }

    NSString *_className = NSStringFromClass([self class]);
    if ([_instanceDict objectForKey:_className]) {
        [_instanceDict removeObjectForKey:_className];
    }
}


@end
