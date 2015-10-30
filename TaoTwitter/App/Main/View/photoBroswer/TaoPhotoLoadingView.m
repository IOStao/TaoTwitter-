//
//  TaoPhotoLoadingView.m
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.

//

#import "TaoPhotoLoadingView.h"
#import "TaoPhotoBrowser.h"
#import "TaoPhotoProgressView.h"

@interface TaoPhotoLoadingView () {
    UILabel *_failureLabel;
    TaoPhotoProgressView *_progressView;
}
@end

@implementation TaoPhotoLoadingView
- (void)setFrame:(CGRect)frame {
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)showFailure {
    [_progressView removeFromSuperview];
    
    if (_failureLabel == nil) {
        _failureLabel = [[UILabel alloc] init];
        _failureLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 44);
        _failureLabel.textAlignment = NSTextAlignmentCenter;
        _failureLabel.center = self.center;
        _failureLabel.text = @"图片下载失败";
        _failureLabel.font = [UIFont boldSystemFontOfSize:20];
        _failureLabel.textColor = [UIColor whiteColor];
        _failureLabel.backgroundColor = [UIColor clearColor];
        _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:_failureLabel];
}

- (void)showLoading {
    [_failureLabel removeFromSuperview];
    
    if (_progressView == nil) {
        _progressView = [[TaoPhotoProgressView alloc] init];
        _progressView.bounds = CGRectMake( 0, 0, 60, 60);
        _progressView.center = self.center;
    }
    _progressView.progress = kMinProgress;
    [self addSubview:_progressView];
}

#pragma mark - customlize method
- (void)setProgress:(float)progress {
    _progress = progress;
    _progressView.progress = progress;
    if (progress >= 1.0) {
        [_progressView removeFromSuperview];
    }
}
@end
