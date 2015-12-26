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

@implementation TaoRStatuesViewLayout

- (void)setRtwitter:(Taostatus *)rtwitter {
    _rtwitter = rtwitter;
    
    NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", rtwitter.user.name, rtwitter.text];
    self.rStatus =  [[TaoTwitterTextLableRegexKitLiteTool shared] attributedTextWithText:retweetContent font:[UIFont systemFontOfSize:statuesFont]];
    CGSize rStatusSize = [self.rStatus boundingRectWithSize:CGSizeMake(TaoScreenWidth - 3 *gloableMargin - 5, HUGE) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
   
      self.rStatuesFrame = CGRectMake(gloableMargin * 2 + 5, 0,rStatusSize.width,rStatusSize.height);

      self.leftLineFrame = CGRectMake(gloableMargin, 0, gloableMargin,CGRectGetMaxY(self.rStatuesFrame));
    
    
    if (rtwitter.pic_urls.count) {
        CGRect rp;
        rp.origin = CGPointMake(gloableMargin,CGRectGetMaxY(self.rStatuesFrame)+ gloableMargin);
        rp.size = [TaoStatusPhotosView sizeWithCount:rtwitter.pic_urls.count];
        self.rphotosViewFrame = rp;
        self.rStatuesViewHeight = CGRectGetMaxY(self.rphotosViewFrame);
    } else {
        self.rphotosViewFrame = CGRectZero;
        self.rStatuesViewHeight = CGRectGetMaxY(self.rStatuesFrame);
    }

}
@end
