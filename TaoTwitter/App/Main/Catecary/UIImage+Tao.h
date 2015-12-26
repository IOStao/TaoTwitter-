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

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor insets:(UIEdgeInsets)insets shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius;

@end
