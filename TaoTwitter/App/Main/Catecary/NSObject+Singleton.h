//
//  NSObject+NSObject_Singleton.h
//  Zhidao
//
//  Created by aggie on 4/16/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Singleton <NSObject>

@optional
//因为是在Category里实现了，所以这里用optional主要是避免报警
+(instancetype)sharedInstance_ks;
+(void)destorySharedInstance_ks;

@end

@interface NSObject (Singleton)

@end
