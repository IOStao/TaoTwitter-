//
//  NSTextAttachment+TaoTextAttachment.m
//  TaoTwitter
//
//  Created by wzt on 15/12/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "NSTextAttachment+TaoTextAttachment.h"
#import <objc/runtime.h>

static char TaoimageDescribtion;

@implementation NSTextAttachment (TaoTextAttachment)

- (void)setImageDescribtion:(NSString *)imageDescribtion {
    objc_setAssociatedObject(self, &TaoimageDescribtion, imageDescribtion, OBJC_ASSOCIATION_COPY);
    
}

- (NSString *)imageDescribtion {
    return objc_getAssociatedObject(self, &TaoimageDescribtion);
}
@end
