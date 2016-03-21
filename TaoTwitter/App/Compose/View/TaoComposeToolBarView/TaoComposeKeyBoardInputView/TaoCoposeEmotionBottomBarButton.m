//
//  TaoCoposeEmotionBottomBarButton.m
//  TaoTwitter
//
//  Created by wzt on 15/11/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoCoposeEmotionBottomBarButton.h"

@implementation TaoCoposeEmotionBottomBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    // 按钮高亮所做的一切操作都不在了
}


@end
