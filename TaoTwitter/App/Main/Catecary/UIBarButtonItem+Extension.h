//
//  UIBarButtonItem+Extension.h
// 
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoNavigationBarConfig.h"

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action type:(TaoNavBarButtonType)type title:(NSString *)title;

@end
