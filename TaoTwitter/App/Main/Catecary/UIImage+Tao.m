//
//  UIImage+Tao.m
//  TaoTwitter
//
//  Created by wzt on 15/10/28.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "UIImage+Tao.h"

@implementation UIImage (Tao)

-(UIImage*)scaleToSize:(CGSize)size{        // 创建一个bitmap的context        // 并把它设置成为当前正在使用的context        //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }        // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];        // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();        // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)resizedImage:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    CGFloat size = MAX(radius*2, 10);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, [[UIScreen mainScreen] scale]);
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth/2, borderWidth/2, size-borderWidth, size-borderWidth) cornerRadius:radius];
    [color setFill];
    [roundedRectPath fill];
    if (borderWidth > 0) {
        [borderColor setStroke];
        roundedRectPath.lineWidth = borderWidth;
        [roundedRectPath stroke];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(size/2-2, size/2-2, size/2-2, size/2-2)];
}

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)radius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth
            backgroundColor:(UIColor *)backgroundColor
                     insets:(UIEdgeInsets)insets
                shadowColor:(UIColor *)shadowColor
              shadowOpacity:(CGFloat)shadowOpacity
               shadowRadius:(CGFloat)shadowRadius
{
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(insets.left, insets.top, 300-insets.left-insets.right, 100-insets.top-insets.bottom)];
    
    childView.layer.shadowColor = shadowColor.CGColor;
    childView.layer.shadowOpacity = shadowOpacity;
    childView.layer.shadowOffset = CGSizeZero;
    childView.layer.shadowRadius = shadowRadius;
    childView.layer.borderWidth = borderWidth;
    childView.layer.borderColor = borderColor.CGColor;
    childView.layer.cornerRadius = radius;
    childView.backgroundColor = color;
    parentView.backgroundColor = backgroundColor;
    [parentView addSubview:childView];
    
    UIGraphicsBeginImageContextWithOptions(parentView.bounds.size, parentView.opaque, 0);
    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];;
}

@end
