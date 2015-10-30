//
//  TaoPhotoLoadingView.h
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.

//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001
@class TaoPhotoBrowser;
@class TaoPhoto;

@interface TaoPhotoLoadingView : UIView
@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;
@end