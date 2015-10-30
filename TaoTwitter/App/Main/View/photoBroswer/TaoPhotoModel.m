//
//  TaoPhoto.m
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.


#import "TaoPhotoModel.h"

@implementation TaoPhotoModel

#pragma mark 截图
- (UIImage *)capture:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView {
    _srcImageView = srcImageView;
    _placeholder = srcImageView.image;
    if (srcImageView.clipsToBounds) {
        _capture = [self capture:srcImageView];
    }
}

@end