//
//  UIColor+Extension.m
//  TaoTwitter
//
//  Created by wzt on 15/10/21.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)tao_titleMenuColor {
    return TaoColor(96, 96, 96, 1);
}

+ (UIColor *)tao_homeEditCellColor {
    return TaoColor(242, 242, 242, 1);
}

+ (UIColor *)tao_homeEditHeaderViewColor {
    return TaoColor(230, 230, 230, 1);
}

+ (UIColor *)tao_AccountCellColor {
    return TaoColor(200, 200, 200, 1);
}

+ (UIColor *)tao_textLableColor {
    return TaoColor(100, 100, 100, 1);
}


+ (UIColor *)tao_foregroundColor {
    return TaoColor(82, 126, 173, 1);
}

+ (UIColor *)tao_separateLineColor {
    return [UIColor nb_colorWithHex:0xBFBFBF];
}

+ (UIColor *)nb_colorWithHex:(uint)hex {
    if (hex <= 0xffffff) {
        hex = 0xff000000 | hex;
    }
    return [UIColor nb_colorWithARGBHex:hex];
}

+ (UIColor *)tao_placeholderColor{
    return [UIColor nb_colorWithHex:0xbbbbbb];
}

+ (UIColor *)nb_colorWithARGBHex:(uint)hex
{
    int red, green, blue, alpha;
    
    blue = hex & 0x000000FF;
    green = ((hex & 0x0000FF00) >> 8);
    red = ((hex & 0x00FF0000) >> 16);
    alpha = ((hex & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha/255.f];
}

@end
