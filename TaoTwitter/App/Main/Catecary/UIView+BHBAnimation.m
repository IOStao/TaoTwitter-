//
//  UIView+BHBAnimation.m
//  BHBPopViewDemo
//
//  Created by 毕洪博 on 15/8/15.
//  Copyright (c) 2015年 毕洪博. All rights reserved.
//

#import "UIView+BHBAnimation.h"

@implementation UIView (BHBAnimation)

//淡入
- (void)fadeInWithTime:(NSTimeInterval)time{
    self.alpha = 0;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
       
    }];
}
//淡出
- (void)fadeOutWithTime:(NSTimeInterval)time{
    self.alpha = 1;
    [UIView animateWithDuration:time animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fadeInWithTime:0];
        });
    }];
}
//缩放
- (void)scalingWithTime:(NSTimeInterval)time andscal:(CGFloat)scal{
    
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeScale(scal,scal);
    }completion:^(BOOL finished) {
        
    }];
    
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform.scale";
//    animation.duration = time;
//    animation.fillMode = kCAFillModeRemoved;
//    animation.removedOnCompletion = YES;
//    animation.toValue = [NSNumber numberWithFloat:scal];
//    [self.layer addAnimation:animation forKey:nil];

}
//旋转
- (void)RevolvingWithTime:(NSTimeInterval)time andDelta:(CGFloat)delta{
    [UIView animateWithDuration:time animations:^{
        self.transform = CGAffineTransformMakeRotation(delta);
    }completion:^(BOOL finished) {
//         [self.layer removeAllAnimations];
    }];
}

@end
