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



#define TaoPhotoFourHieight 150
#define TaoPhotoOneHeight 200
#define TaoStatusPhotoWH (TaoScreenWidth - 30)/3
#define TaoStatusPhotoMargin 5
#define TaoPhotoMagin 10
#define TaoStatusPhotoMaxCol(count) ((count==4)?2:3)
#define TaoPhotoOneW TaoScreenWidth - 2 *TaoPhotoMagin


@interface TaoStatusPhotosView()
@end
@implementation TaoStatusPhotosView

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    NSUInteger photosCount = photos.count;
    
    while (self.subviews.count < photosCount) {
        TaoStatusPhotoView *photoView = [[TaoStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    // 遍历所有的图片控件，设置图片
    [self.subviews enumerateObjectsUsingBlock:^( TaoStatusPhotoView *  obj, NSUInteger idx, BOOL *  stop) {
        TaoStatusPhotoView *photoView = self.subviews[idx];
        photoView.tag = idx;
        [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget: self action:@selector(imageViewTap:)]];
        if (idx < photosCount) { // 显示
            photoView.photo = [[TaoPhoto alloc] initWithDictionary:photos[idx] error:nil];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSUInteger photosCount = self.photos.count;
    int maxCol = 3;
    for (int i = 0; i<photosCount; i++) {
#warning 抽时间优化
        TaoStatusPhotoView *photoView = self.subviews[i];
        if (photosCount == 1 ) {
            photoView.x =  0;
            photoView.y = 0;
            photoView.width = TaoPhotoOneW;
            photoView.height = TaoPhotoOneHeight;
        }else if(photosCount == 2) {
            photoView.x =  i * ((TaoPhotoOneW - TaoStatusPhotoMargin) /2 + TaoStatusPhotoMargin);
            photoView.y = 0;
            photoView.width = (TaoPhotoOneW - TaoStatusPhotoMargin) /2;
            photoView.height = TaoPhotoOneHeight;
        }else if(photosCount == 4 || photosCount == 7) {
            if (i == 0) {
                photoView.x =  0;
                photoView.y = 0;
                photoView.width = TaoPhotoOneW;
                photoView.height = TaoPhotoFourHieight;
            } else {
                int col = (i-1) % 3;
                int row = (i -1)/ 3 + 1;
                photoView.x = col * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
                photoView.y = row * (TaoPhotoFourHieight + TaoStatusPhotoMargin);
                photoView.width = TaoStatusPhotoWH;
                photoView.height = TaoStatusPhotoWH;            }
        }else  if (photosCount == 5|| photosCount == 8){
            if (i <=1) {
                photoView.x =  i * ((TaoPhotoOneW - TaoStatusPhotoMargin) /2 + TaoStatusPhotoMargin);
                photoView.y = 0;
                photoView.width = (TaoPhotoOneW - TaoStatusPhotoMargin) /2;
                photoView.height = TaoPhotoFourHieight;
            }else {
                int col = (i-2) % 3 ;
                int row = (i-2)/ 3 +1 ;
                photoView.x = col * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
                photoView.y = row * (TaoPhotoFourHieight + TaoStatusPhotoMargin);
                if (i>4)
                photoView.y = (TaoPhotoFourHieight + 2*TaoStatusPhotoMargin + TaoStatusPhotoWH);
                photoView.width = TaoStatusPhotoWH;
                photoView.height = TaoStatusPhotoWH;
            }
        } else {
            int col = i % maxCol;
            photoView.x = col * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
            int row = i / maxCol;
            photoView.y = row * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
            photoView.width = TaoStatusPhotoWH;
            photoView.height = TaoStatusPhotoWH;
        }
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count {
    // 最大列数（一行最多有多少列）
    int maxCols = TaoStatusPhotoMaxCol(count);
    
    if (count == 1 || count == 2) {
        return CGSizeMake(TaoScreenWidth - 2 *TaoPhotoMagin, TaoPhotoOneHeight);
    } else if (count == 4 || count == 5) {
        return CGSizeMake(TaoScreenWidth - 2 *TaoPhotoMagin, TaoPhotoFourHieight + TaoStatusPhotoWH + TaoStatusPhotoMargin);
    } else if (count == 8 || count == 7) {
        return CGSizeMake(TaoScreenWidth - 2 *TaoPhotoMagin, TaoPhotoFourHieight + 2*(TaoStatusPhotoWH + TaoStatusPhotoMargin));
    }else {
        NSUInteger cols = (count >= maxCols)? maxCols : count;
        CGFloat photosW = cols * TaoStatusPhotoWH + (cols - 1) * TaoStatusPhotoMargin;
        NSUInteger rows = (count + maxCols - 1) / maxCols;
        CGFloat photosH = rows * TaoStatusPhotoWH + (rows - 1) * TaoStatusPhotoMargin;
        return CGSizeMake(photosW, photosH);
   }
}

- (void)imageViewTap:(UITapGestureRecognizer *)recongnizer{
    TaoPhotoBrowser *browser = [[TaoPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    
    [self.photos enumerateObjectsUsingBlock:^(TaoPhoto *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaoPhotoModel *photo = [[TaoPhotoModel alloc] init];
        photo.url = [NSURL URLWithString:[[[TaoPhoto alloc] initWithDictionary:self.photos[idx] error:nil].thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        photo.srcImageView = self.subviews[idx];
        [photos addObject:photo];
    }];
   
    browser.photos = photos;
    browser.currentPhotoIndex = recongnizer.view.tag;
    [browser show];
}

#pragma mark - photobrowser代理方法
@end
