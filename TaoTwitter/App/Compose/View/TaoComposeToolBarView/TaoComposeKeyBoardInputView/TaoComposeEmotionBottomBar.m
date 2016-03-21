//
//  TaoComposeEmotionBottomBar.m
//  TaoTwitter
//
//  Created by wzt on 15/11/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeEmotionBottomBar.h"
#import "TaoCoposeEmotionBottomBarButton.h"

@interface TaoComposeEmotionBottomBar ()
@property (nonatomic, weak) TaoCoposeEmotionBottomBarButton *selectedBtn;

@end

@implementation TaoComposeEmotionBottomBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        [self setupBtn:@"最近" buttonType:TaoEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:TaoEmotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:TaoEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:TaoEmotionTabBarButtonTypeLxh];
        [TaoNotificationCenter addObserver:self selector:@selector(TaoComposeEmotionListViewDidScroll:) name:TaoComposeEmotionListViewDidScrollNotification object:nil];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentSize = CGSizeMake(self.width + 1, 0);
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        TaoCoposeEmotionBottomBarButton *btn = self.subviews[i];
        btn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
    }
    
}

- (TaoCoposeEmotionBottomBarButton *)setupBtn:(NSString *)title buttonType:(TaoEmotionTabBarButtonType)buttonType
{
    // 创建按钮
    TaoCoposeEmotionBottomBarButton *btn = [[TaoCoposeEmotionBottomBarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [self addSubview:btn];
    
    // 设置背景图片
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;
}

- (void)btnClick:(TaoCoposeEmotionBottomBarButton *)btn {
    
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    if ([self.btnDelegate respondsToSelector:@selector(TaoComposeEmotionBottomBarBtnTapWithBtnType:)]) {
        [self.btnDelegate TaoComposeEmotionBottomBarBtnTapWithBtnType:(TaoEmotionTabBarButtonType)btn.tag];
    }
}

- (void)setBtnDelegate:(id<TaoComposeEmotionBottomBarDelegate>)btnDelegate {
    _btnDelegate = btnDelegate;
    
    [self btnClick:(TaoCoposeEmotionBottomBarButton *)[self.subviews objectAtIndex:TaoEmotionTabBarButtonTypeRecent  ]];
}

- (void)TaoComposeEmotionListViewDidScroll:(NSNotification *)notification{
    self.selectedBtn.enabled = YES;
    TaoCoposeEmotionBottomBarButton *btn = (TaoCoposeEmotionBottomBarButton *)[self.subviews objectAtIndex:[[notification.userInfo objectForKey:@"type"] integerValue]];
    btn.enabled = NO;
    self.selectedBtn = btn;
}

- (void)dealloc {
    [TaoNotificationCenter removeObserver:self];
}
@end
