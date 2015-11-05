//
//  UIImage+Tao.h
//  TaoTwitter
//
//  Created by wzt on 15/10/28.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tao)
-(UIImage*)scaleToSize:(CGSize)size;

+ (UIImage *)resizedImage:(NSString *)name;
@end
