//
//  TaoComeposeWindow.h
//  TaoTwitter
//
//  Created by wzt on 15/11/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoComeposeWindow : UIWindow

+ (TaoComeposeWindow *)sharedInstance;
- (void)show;
- (void)removeWithAnimation:(BOOL)animation;
@end
