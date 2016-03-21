
//  btn点击实现。
//  TaoComeposeWindow.m
//  TaoTwitter
//
//  Created by wzt on 15/11/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Masonry.h>
#import "TaoPopMenuView.h"
#import "TaoComeposeWindow.h"
#import "POP.h"
#import "UIView+BHBAnimation.h"

typedef enum : NSUInteger {
    popMenuShow,
    popmenuRmemove,
} popMenuStyle;

#define ComposeViewTop  120
#define ComposeViewcount  10
#define ComposeViewWidth 100
#define ComposeViewHeight 120
#define bottomBarHeight  30
#define numsProcolumn   3
#define row            2
#define speed         0.06
#define ComposeViewMagin      (TaoScreenWidth - numsProcolumn * ComposeViewWidth)/ (numsProcolumn +1)
static id sharedInstance = nil;

@interface TaoComeposeWindow ()<TaoPopMenuViewDelegae>
@property (nonatomic, strong) NSArray * titleName;
@property (nonatomic, strong) NSMutableArray * composeView;
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) UIButton *transformBtn;
@property(nonatomic, weak) UIButton *returnBtn;
@property(nonatomic, weak) UIImageView *moreComposeImage;
@property (nonatomic,assign) BOOL btnCanceled;
@end

@implementation TaoComeposeWindow

+ (TaoComeposeWindow *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configerSelf];
    }
    return self;
}

- (void)configerSelf {
    
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.96;
    //Image
    UIImageView *backGroudview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_slogan"]];
    [self addSubview:backGroudview];
    
    [backGroudview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo((@0));
        make.top.equalTo(@(100));
    }];
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator  = NO;
    scrollView.scrollEnabled = NO;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissMiss)]];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backGroudview.mas_bottom);
        make.left.right.equalTo(@(0));
        make.bottom.equalTo(@(-bottomBarHeight));
    }];
    //bottomBar
    UIView *bottomBar = [[UIView alloc] init];
    bottomBar.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom);
        make.left.right.bottom.equalTo(@(0));
    }];
    
    //transform
    UIButton  *transformBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [transformBtn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close"] forState:UIControlStateNormal];
    [transformBtn setBackgroundColor:[UIColor clearColor]];
    [transformBtn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:transformBtn];
    self.transformBtn = transformBtn;
    
    //returnBtn
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_return"] forState:UIControlStateNormal];
    [returnBtn setBackgroundColor:[UIColor clearColor]];
    [returnBtn addTarget:self action:@selector(returnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:returnBtn];
    self.returnBtn = returnBtn;
    
    
    //button lable
    for (int i = 0; i < ComposeViewcount; i ++) {
        TaoPopMenuView *composeView = [[TaoPopMenuView alloc] initWithIndex:i];
        composeView.delegate = self;
        composeView.tag = i;
        [scrollView addSubview:composeView];
        [self.composeView addObject:composeView];
    }
    
}

#pragma mark appear
- (void)show {
    
    [self returnBtnClick];
    [self beginAnimationWithStyle:popMenuShow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self makeKeyWindow];
        self.hidden = NO;
    });
}

- (void)removeWithAnimation:(BOOL)animation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resignKeyWindow];
        self.hidden = YES;
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformIdentity;
            [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.transform = CGAffineTransformIdentity;
            }];
        }];
    });
    if (animation ) {
      [self beginAnimationWithStyle:popmenuRmemove];
    }
   
}

- (void)dissMiss {
    [self removeWithAnimation:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeWithAnimation:YES];
}

#pragma mark 手势点击代理

- (void)TaoPopMenuViewClick:(TaoPopMenuView *)menuView ComposeImage:(UIImageView *)composeImage {
    if ((composeBtnType)menuView.tag == composeBtnTypeMore) {
        //添加按钮
        self.scrollView.scrollEnabled = YES;
        self.moreComposeImage = composeImage;
        [self.scrollView setContentOffset:CGPointMake(TaoScreenWidth, 0) animated:YES];
        //bottomBar变化
        [self constraintsChangeWithStyle:popmenuRmemove];
        [self.moreComposeImage scalingWithTime:0.15 andscal:1.2];
    }else {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIButton   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:menuView]) {
                [obj scalingWithTime:0.4 andscal:2.0];
                [obj fadeOutWithTime:0.4];
            }else {
                [obj scalingWithTime:0.4 andscal:0.1];
                [obj fadeOutWithTime:0.4];
            }
        }];
        [self removeWithAnimation:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(TaoComeposeWindowModalVcWithType:)]) {
                [self.delegate TaoComeposeWindowModalVcWithType:menuView.tag];
            }
        });
        
    }

}

- (void)returnBtnClick {
    self.moreComposeImage.transform = CGAffineTransformIdentity;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self constraintsChangeWithStyle:popMenuShow];
}

- (void)constraintsChangeWithStyle:(popMenuStyle)style{
    
    if (style == popMenuShow) {
        [self.transformBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@(0));
            make.left.equalTo(@(0));
        }];
        
        [self.returnBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(@(0));
            make.right.equalTo(self.transformBtn.mas_left);
        }];

    }else {
        [self.transformBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(@(0));
            make.left.equalTo(@(0)).offset(TaoScreenWidth/2);
        }];
        
        [self.returnBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(@(0));
            make.right.equalTo(@(0)).offset(-TaoScreenWidth/2);
        }];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark animation
- (void)beginAnimationWithStyle:(popMenuStyle)style{
    
    [self.composeView enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat baseWidth = idx / (numsProcolumn * row) * [UIScreen mainScreen].bounds.size.width;
        CGFloat Ychange   = ((idx %(numsProcolumn * row ))/ numsProcolumn);
        CGFloat Xchange   = (idx % numsProcolumn);
        CGFloat TimeChange = idx % (numsProcolumn * row);
        CGFloat beginTime;

        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        springAnimation.removedOnCompletion = YES;

        if (style == popMenuShow) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
            CGFloat  Y = ComposeViewTop +(ComposeViewMagin + ComposeViewHeight) * Ychange  + ComposeViewHeight/2;
            obj.x =  baseWidth +  ComposeViewMagin + (ComposeViewWidth + ComposeViewMagin) * Xchange;
            obj.size = CGSizeMake(ComposeViewWidth, ComposeViewHeight);
            obj.y = TaoScreenHeight ;

            springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX, TaoScreenHeight )];
            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX, Y)];
            beginTime = TimeChange * speed;
            
        }else {
            springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX, obj.centerY)];
            springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX, TaoScreenHeight )];
            beginTime =   (row * numsProcolumn - TimeChange) * speed;
        }
        springAnimation.springSpeed = 15 - beginTime * 2;
        springAnimation.springBounciness = 5 - beginTime *2 ;
        springAnimation.beginTime = CACurrentMediaTime() + beginTime ;
        [obj.layer pop_addAnimation:springAnimation forKey:@"changeposition"];
    }];
    
    [UIView animateWithDuration:0.55 animations:^{
        if(style == popMenuShow) {
            self.transformBtn.transform = CGAffineTransformIdentity;
        }else {
            if (!self.returnBtn.width) {
                self.transformBtn.transform = CGAffineTransformRotate(self.transformBtn.transform, M_PI_4);
            }
        }
    }];
}

#pragma mark getter
- (NSArray *)titleName {
    if (!_titleName) {
        _titleName = [NSArray arrayWithObjects:@"文字",@"相册",@"长微博",@"签到",@"点评",@"更多",@"好友圈",@"微博相机",@"音乐",@"商品",nil];
    }
    return _titleName;
}

- (NSMutableArray *)composeView {
    if (!_composeView) {
        _composeView = [NSMutableArray array];
    }
    return _composeView;
}

- (void)dealloc {
    sharedInstance = nil;
    NSLog(@"%@dealloc",[self class]);
}
@end
