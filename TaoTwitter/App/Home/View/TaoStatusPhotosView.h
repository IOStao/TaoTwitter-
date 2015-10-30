//
//  TaoStatusPhotosView.h
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoStatusPhotosView :UIView
@property (nonatomic, strong) NSArray *photos;

+ (CGSize)sizeWithCount:(NSUInteger)count;
@end
