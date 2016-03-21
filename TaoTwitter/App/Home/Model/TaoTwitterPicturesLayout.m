//
//  TaoTwitterPictureLayout.m
//  TaoTwitter
//
//  Created by wzt on 15/12/29.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterPicturesLayout.h"

#define TaoPhotoFourHieight 150
#define TaoPhotoOneHeight 200
#define TaoStatusPhotoWH (TaoScreenWidth - 30)/3
#define TaoStatusPhotoMargin 5
#define TaoPhotoMagin 10
#define TaoStatusPhotoMaxCol(count) ((count==4)?2:3)
#define TaoPhotoOneW TaoScreenWidth - 2 *TaoPhotoMagin


@implementation TaoTwitterPicturesLayout

- (void)setTwitter:(Taostatus *)twitter {
    _twitter = twitter;
    
    NSInteger  count = twitter.pic_urls.count;
    int maxCols = TaoStatusPhotoMaxCol(count);
  //size
    if (count == 1 || count == 2) {
        self.pictureSize =  CGSizeMake(TaoScreenWidth - 2 *TaoPhotoMagin, TaoPhotoOneHeight);
    } else if (count == 4 || count == 5) {
        self.pictureSize = CGSizeMake(TaoScreenWidth - 2 *TaoPhotoMagin, TaoPhotoFourHieight + TaoStatusPhotoWH + TaoStatusPhotoMargin);
    } else if (count == 8 || count == 7) {
        self.pictureSize = CGSizeMake(TaoScreenWidth - 2 *TaoPhotoMagin, TaoPhotoFourHieight + 2*(TaoStatusPhotoWH + TaoStatusPhotoMargin));
    }else {
        NSUInteger cols = (count >= maxCols)? maxCols : count;
        CGFloat photosW = cols * TaoStatusPhotoWH + (cols - 1) * TaoStatusPhotoMargin;
        NSUInteger rows = (count + maxCols - 1) / maxCols;
        CGFloat photosH = rows * TaoStatusPhotoWH + (rows - 1) * TaoStatusPhotoMargin;
        self.pictureSize = CGSizeMake(photosW, photosH);
    }
   
  //layout
    NSUInteger photosCount = count;
    int maxCol = 3;
    CGRect picFrame = CGRectZero;
    CGFloat X;
    CGFloat Y;
    CGFloat Width;
    CGFloat Height;
    for (int i = 0; i<photosCount; i++) {
#warning 抽时间优化
        if (photosCount == 1 ) {
            X =  0;
            Y = 0;
            Width = TaoPhotoOneW;
            Height = TaoPhotoOneHeight;
        }else if(photosCount == 2) {
            X =  i * ((TaoPhotoOneW - TaoStatusPhotoMargin) /2 + TaoStatusPhotoMargin);
            Y = 0;
            Width = (TaoPhotoOneW - TaoStatusPhotoMargin) /2;
            Height = TaoPhotoOneHeight;
        }else if(photosCount == 4 || photosCount == 7) {
            if (i == 0) {
                X =  0;
                Y = 0;
                Width = TaoPhotoOneW;
                Height = TaoPhotoFourHieight;
            } else {
                int col = (i-1) % 3;
                int row = (i -1)/ 3 + 1;
                X = col * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
                Y = row * (TaoPhotoFourHieight + TaoStatusPhotoMargin);
                Width = TaoStatusPhotoWH;
                Height = TaoStatusPhotoWH;
                if (i>3)
                    Y = (TaoPhotoFourHieight + 2*TaoStatusPhotoMargin + TaoStatusPhotoWH);
                Width = TaoStatusPhotoWH;
                Height = TaoStatusPhotoWH;}
        }else  if (photosCount == 5|| photosCount == 8){
            if (i <=1) {
                X =  i * ((TaoPhotoOneW - TaoStatusPhotoMargin) /2 + TaoStatusPhotoMargin);
                Y = 0;
                Width = (TaoPhotoOneW - TaoStatusPhotoMargin) /2;
                Height = TaoPhotoFourHieight;
            }else {
                int col = (i-2) % 3 ;
                int row = (i-2)/ 3 +1 ;
                X = col * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
                Y = row * (TaoPhotoFourHieight + TaoStatusPhotoMargin);
                if (i>4)
                    Y = (TaoPhotoFourHieight + 2*TaoStatusPhotoMargin + TaoStatusPhotoWH);
                Width = TaoStatusPhotoWH;
                Height = TaoStatusPhotoWH;
            }
        } else {
            int col = i % maxCol;
            X = col * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
            int row = i / maxCol;
            Y = row * (TaoStatusPhotoWH + TaoStatusPhotoMargin);
            Width = TaoStatusPhotoWH;
            Height = TaoStatusPhotoWH;
        }
        
        picFrame = CGRectMake(X, Y, Width, Height);
        [self.frameArry addObject:[NSValue valueWithCGRect:picFrame]];
    }
}

- (NSMutableArray *)frameArry {
    if (!_frameArry) {
        _frameArry = [NSMutableArray array];
    }
    return _frameArry;
}
@end
