//
//  NBTabBar.m
//  TaoTwitter
//
//  Created by wzt on 15/10/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "NBTabBar.h"
#import "TaoComeposeWindow.h"
#define tabBarItemHeight 36
#define tabBarItemY 3
#define tabBarHeight 40

@interface NBTabBar ()
@property(nonatomic, weak) UIButton *plusBtn;

@end

@implementation NBTabBar
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
     CGFloat tabbarButtonW = self.width/5;
    self.plusBtn.centerX = self.width * 0.5;
    self.plusBtn.centerY = self.height *0.5;
    self.plusBtn.size = self.plusBtn.currentBackgroundImage.size;

     __block CGFloat index = 0;
    [self.subviews enumerateObjectsUsingBlock:^( UIView * obj, NSUInteger idx, BOOL *  stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            obj.x = tabbarButtonW * index;
            obj.width = tabbarButtonW;
            
            index ++;
            if (index == 2) {
                index ++;
            }
        }
    }];
}

- (void)plusClick {
    TaoComeposeWindow *compose = [TaoComeposeWindow sharedInstance];
    [compose show];
    
}

@end
