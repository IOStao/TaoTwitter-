//
//  TaoGrowingTextView.h
//  TaoTwitter
//
//  Created by wzt on 15/12/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoGrowingTextView : UITextView

@property(nonatomic, assign) IBInspectable CGFloat maxHeight;
@property(nonatomic, assign) IBInspectable CGFloat minHeight;
@property(nonatomic, copy) IBInspectable NSString *placeholder;
@property(nonatomic) IBInspectable UIColor *placeholderColor;

@end
