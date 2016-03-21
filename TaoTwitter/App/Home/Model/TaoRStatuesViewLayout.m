//
//  TaoRStatuesViewLayout.m
//  TaoTwitter
//
//  Created by wzt on 15/12/11.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoRStatuesViewLayout.h"
#import "TaoStatusPhotosView.h"
#import "TaoTwitterTextLableRegexKitLiteTool.h"
#import <YYText/YYText.h>
#import "TaoTwitterPicturesLayout.h"


@implementation TaoRStatuesViewLayout

- (void)setRtwitter:(Taostatus *)rtwitter {
    _rtwitter = rtwitter;
    
     NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", rtwitter.user.name, rtwitter.text];
    YYTextContainer *statuesContainer = [YYTextContainer containerWithSize:CGSizeMake(TaoScreenWidth - 3 *gloableMargin - 5, HUGE)];
    self.rStatuesLayout = [YYTextLayout layoutWithContainer:statuesContainer text:[[TaoTwitterTextLableRegexKitLiteTool shared]attributedTextWithText:retweetContent font:[UIFont systemFontOfSize:statuesFont]]];
    
    self.rStatuesFrame = CGRectMake(gloableMargin * 2 + 5, 0,self.rStatuesLayout.textBoundingSize.width,self.rStatuesLayout.textBoundingSize.height);
    
    self.leftLineFrame = CGRectMake(gloableMargin, 0, gloableMargin,CGRectGetMaxY(self.rStatuesFrame));
    
    
    if (rtwitter.pic_urls.count) {
        self.rPictureLayout = [[TaoTwitterPicturesLayout alloc]init];
        self.rPictureLayout.twitter = rtwitter;
        CGRect rp;
        rp.origin = CGPointMake(gloableMargin,CGRectGetMaxY(self.rStatuesFrame)+ gloableMargin);
        rp.size = self.rPictureLayout.pictureSize;
        self.rphotosViewFrame = rp;
        self.rStatuesViewHeight = CGRectGetMaxY(self.rphotosViewFrame);
    } else {
        self.rphotosViewFrame = CGRectZero;
        self.rStatuesViewHeight = CGRectGetMaxY(self.rStatuesFrame);
    }

}
@end
