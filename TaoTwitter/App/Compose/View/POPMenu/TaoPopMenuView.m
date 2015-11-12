//
//  TaoPopMenuView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/12.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoPopMenuView.h"
#import "UIView+BHBAnimation.h"
#import <Masonry.h>

#define BtnWidth 71
#define BtnHeight 71
#define LableHeight 29
#define ComposeViewWidth 100
#define ComposeViewHeight 120

@interface TaoPopMenuView ()
@property (nonatomic, strong) NSArray * titleName;
@property (nonatomic, weak ) UIImageView *composeImage;
@property (nonatomic, weak ) UILabel  *composeLable;
@property (nonatomic,assign) BOOL btnCanceled;
@end

@implementation TaoPopMenuView

- (instancetype)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        NSString *name = [NSString stringWithFormat:@"tabbar_compose_%ld",index];
        UIImageView *composeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        [self addSubview:composeImage];
        self.composeImage = composeImage;
        
        UILabel *composeLable = [[UILabel alloc] init];
        [self addSubview:composeLable];
        composeLable.text = [self.titleName objectAtIndex:index];
        composeLable = [self configerLable:composeLable];
        [self layoutComposeView];
        
        UIButton *composeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ComposeViewWidth, ComposeViewHeight)];
        [self addSubview:composeBtn];
        [self configerBnt:composeBtn];
    }
    return self;
}

- (void)layoutComposeView {
    [self.subviews enumerateObjectsUsingBlock:^( UIView *  view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:[UIImageView class]]) {
           
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(@(0));
                make.height.equalTo(@(BtnHeight)).priorityHigh();
                make.width.equalTo(@(BtnWidth)).priorityHigh();
                make.top.equalTo(@(20));
            }];
            
        }else {
            view.frame = CGRectMake(0, BtnHeight, BtnWidth, LableHeight);
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(20+BtnHeight)).priorityHigh();
                make.bottom.left.right.equalTo(@(0));
                
            }];
        }
    }];

}

- (UIButton *)configerBnt:(UIButton *)composeBtn {
    composeBtn.backgroundColor = [UIColor clearColor];
    [composeBtn addTarget:self action:@selector(composeBtnDown) forControlEvents:UIControlEventTouchDown];
    [composeBtn addTarget:self action:@selector(composeCancle) forControlEvents:UIControlEventTouchDragInside];
    [composeBtn addTarget:self action:@selector(composeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return composeBtn;
}

- (UILabel *)configerLable:(UILabel *)composeLable {
    composeLable.textAlignment = NSTextAlignmentCenter ;
    composeLable.textColor = [UIColor tao_textLableColor];
    composeLable.font = [UIFont systemFontOfSize:15];
    return composeLable;
}

- (void)composeBtnClick{
    if (self.btnCanceled) {
        self.btnCanceled = NO;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(TaoPopMenuViewClick:ComposeImage:)]) {
        [self.delegate TaoPopMenuViewClick:self ComposeImage:self.composeImage];
    }
    
}

- (void)composeBtnDown{
    [self.composeImage scalingWithTime:0.15 andscal:1.2];
    self.btnCanceled = NO;
}

- (void)composeCancle{
    self.btnCanceled = YES;
    [self.composeImage scalingWithTime:.15 andscal:1];
}

- (NSArray *)titleName {
    if (!_titleName) {
        _titleName = [NSArray arrayWithObjects:@"文字",@"相册",@"长微博",@"签到",@"点评",@"更多",@"好友圈",@"微博相机",@"音乐",@"商品",nil];
    }
    return _titleName;
}

- (void)dealloc {
    NSLog(@"%@dealloc",[self class]);
}
@end
