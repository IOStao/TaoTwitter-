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
@end