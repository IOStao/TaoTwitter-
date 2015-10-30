//
//  TaoStatusPhotoView.m
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoStatusPhotoView.h"
#import <UIImageView+WebCache.h>




@interface TaoStatusPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setPhoto:(TaoPhoto *)photo {
    _photo = photo;
    [self returnBigImageUrl:photo.thumbnail_pic];
    // 设置图片
    [self sd_setImageWithURL:[NSURL URLWithString: [self returnBigImageUrl: photo.thumbnail_pic]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    if ([photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    }
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

- (NSString *)returnBigImageUrl:(NSString *)url {
    NSString *string  = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return string;
}
@end