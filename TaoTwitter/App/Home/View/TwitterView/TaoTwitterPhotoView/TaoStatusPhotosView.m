//
//  TaoStatusPhotosView.m
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoStatusPhotosView.h"
#import "TaoStatusPhotoView.h"
#import "TaoPhotoBrowser.h"
#import "TaoTwitterPicturesLayout.h"


@interface TaoStatusPhotosView()
@end
@implementation TaoStatusPhotosView

- (void)setPictureLayout:(TaoTwitterPicturesLayout *)pictureLayout {
    _pictureLayout = pictureLayout;
    NSUInteger photosCount = pictureLayout.twitter.pic_urls.count;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    while (self.subviews.count < photosCount) {
        TaoStatusPhotoView *photoView = [[TaoStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    // 遍历所有的图片控件，设置图片
    [self.subviews enumerateObjectsUsingBlock:^( TaoStatusPhotoView *  obj, NSUInteger idx, BOOL *  stop) {
        TaoStatusPhotoView *photoView = self.subviews[idx];
        photoView.tag = idx;
        [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(imageViewTap:)]];
        if (idx < photosCount) {
            photoView.frame = [[pictureLayout.frameArry objectAtIndex:idx]CGRectValue];// 显示
            photoView.photo = [[TaoPhoto alloc] initWithDictionary:pictureLayout.twitter.pic_urls[idx] error:nil];
            
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }];
}


- (void)imageViewTap:(UITapGestureRecognizer *)recongnizer{
    TaoPhotoBrowser *browser = [[TaoPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    
    __weak typeof(self) _self = self;
    [self.pictureLayout.twitter.pic_urls enumerateObjectsUsingBlock:^(TaoPhoto *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaoPhotoModel *photo = [[TaoPhotoModel alloc] init];
        photo.url = [NSURL URLWithString:[[[TaoPhoto alloc] initWithDictionary:_self.pictureLayout.twitter.pic_urls[idx] error:nil].thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        photo.srcImageView = _self.subviews[idx];
        
        [photos addObject:photo];
    }];
   
    browser.photos = photos;
    browser.currentPhotoIndex = recongnizer.view.tag;
    [browser show];
}

#pragma mark - photobrowser代理方法

@end
