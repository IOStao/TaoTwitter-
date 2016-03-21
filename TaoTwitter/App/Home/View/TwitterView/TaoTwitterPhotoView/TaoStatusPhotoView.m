//
//  TaoStatusPhotoView.m
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoStatusPhotoView.h"
#import <YYWebImage/CALayer+YYWebImage.h>


@interface TaoStatusPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@property (nonatomic, weak) UIImageView *longImageView;
@end

@implementation TaoStatusPhotoView
- (UIImageView *)gifView {
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (UIImageView *)longImageView {
    if (!_longImageView) {
        UIImage *longImage = [UIImage imageNamed:@"timeline_image_longimage"];
        UIImageView *longImageView = [[UIImageView alloc] initWithImage:longImage];
        [self addSubview:longImageView];
        self.longImageView = longImageView;
    }
    return _longImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill ;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;

    }
    return self;
}

- (void)setPhoto:(TaoPhoto *)photo {
    _photo = photo;

    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
    self.longImageView.hidden = YES;
    
    
    self.image = [UIImage imageNamed:@"timeline_image_placeholder"];
    __weak typeof(self) _self = self;
    [self.layer yy_setImageWithURL:[NSURL URLWithString:[self returnBigImageUrl:photo.thumbnail_pic]]
                         placeholder:[UIImage imageNamed:@"timeline_image_placeholder"]
                             options:YYWebImageOptionAvoidSetImage 
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                              if (image && stage == YYWebImageStageFinished) {
                                  int width = image.size.width;
                                  int height = image.size.height;
                                  
                                  _self.longImageView.hidden = !(width > 0 && (float)height / width > 3);
                               
                                  _self.image = image;
                                  if (from != YYWebImageFromMemoryCacheFast) {
                                      CATransition *transition = [CATransition animation];
                                      transition.duration = 0.15;
                                      transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                      transition.type = kCATransitionFade;
                                      [_self.layer addAnimation:transition forKey:@"contents"];
                                  }
                              }
      }];
    
#warning 优化图片
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
    
    self.longImageView.x = self.width - self.gifView.width;
    self.longImageView.y = self.height - self.gifView.height;
    
    
}

- (NSString *)returnBigImageUrl:(NSString *)url {
    NSString *string  = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return string;
}
@end