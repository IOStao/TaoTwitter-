//
//  TaoTwitterCellBottomBar.m
//  TaoTwitter
//
//  Created by wzt on 15/11/1.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterCellBottomBar.h"
#import <YYText/YYText.h>
#import "UIImage+Tao.h"
#import "CALayer+YYAdd.h"
#import "TaoTwitterCellBarLayout.h"
#import "TaoTwitterTextLable.h"
#define lineWidth 1
@interface TaoTwitterCellBottomBar()
@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *repostImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) TaoTwitterTextLable *repostLabel;
@property (nonatomic, strong) TaoTwitterTextLable *commentLabel;
@property (nonatomic, strong) TaoTwitterTextLable *likeLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;

@property (nonatomic, assign) BOOL isLiked;
@end

@implementation TaoTwitterCellBottomBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = TaoScreenWidth;
        frame.size.height = toolBarHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _repostButton.exclusiveTouch = YES;
    _repostButton.size = CGSizeMake(self.width / 3.0, self.height);
    [_repostButton setBackgroundImage:[UIImage imageWithColor:[UIColor nb_colorWithHex:0xf0f0f0]] forState:UIControlStateHighlighted];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.size = CGSizeMake(self.width / 3.0, self.height);
    _commentButton.left = self.width / 3.0;
    [_commentButton setBackgroundImage:[UIImage imageWithColor:[UIColor nb_colorWithHex:0xf0f0f0]] forState:UIControlStateHighlighted];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.exclusiveTouch = YES;
    _likeButton.size = CGSizeMake(self.width / 3.0, self.height);
    _likeButton.left = self.width / 3.0 * 2.0;
    [_likeButton setBackgroundImage:[UIImage imageWithColor:[UIColor nb_colorWithHex:0xf0f0f0]] forState:UIControlStateHighlighted];
    
    _repostImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_icon_retweet"]];
    _repostImageView.centerY = self.height / 2;
    [_repostButton addSubview:_repostImageView];
    _commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_icon_comment"]];
    _commentImageView.centerY = self.height / 2;
    [_commentButton addSubview:_commentImageView];
    _likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_icon_unlike"]];
    _likeImageView.centerY = self.height / 2;
    [_likeButton addSubview:_likeImageView];
    
    _repostLabel = [[TaoTwitterTextLable alloc] init];
    _repostLabel.userInteractionEnabled = NO;
    _repostLabel.height = self.height;
    _repostLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [_repostButton addSubview:_repostLabel];
    
    _commentLabel = [[TaoTwitterTextLable alloc] init];
    _commentLabel.userInteractionEnabled = NO;
    _commentLabel.height = self.height;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [_commentButton addSubview:_commentLabel];
    
    _likeLabel = [[TaoTwitterTextLable alloc] init];
    _likeLabel.userInteractionEnabled = NO;
    _likeLabel.height = self.height;
    _likeLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [_likeButton addSubview:_likeLabel];
    
    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
    NSArray *locations = @[@0.2, @0.5, @0.8];
    
    _line1 = [CAGradientLayer layer];
    _line1.colors = colors;
    _line1.locations = locations;
    _line1.startPoint = CGPointMake(0, 0);
    _line1.endPoint = CGPointMake(0, 1);
    _line1.size = CGSizeMake(1, self.height);
    _line1.left = _repostButton.right;
    
    _line2 = [CAGradientLayer layer];
    _line2.colors = colors;
    _line2.locations = locations;
    _line2.startPoint = CGPointMake(0, 0);
    _line2.endPoint = CGPointMake(0, 1);
    _line2.size = CGSizeMake(1, self.height);
    _line2.left = _commentButton.right;
    
    _topLine = [CALayer layer];
    _topLine.size = CGSizeMake(self.width, 1);
    _topLine.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.09].CGColor;
    
    _bottomLine = [CALayer layer];
    _bottomLine.size = _topLine.size;
    _bottomLine.bottom = self.height;
    _bottomLine.backgroundColor =[UIColor nb_colorWithHex:0xe8e8e8].CGColor;
    
    [self addSubview:_repostButton];
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];
    [self.layer addSublayer:_line1];
    [self.layer addSublayer:_line2];
    [self.layer addSublayer:_topLine];
    [self.layer addSublayer:_bottomLine];
    
    self.isLiked = NO;
    [_likeButton addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    return self;
}

- (void)setCellBarLayout:(TaoTwitterCellBarLayout *)cellBarLayout {
    _cellBarLayout = cellBarLayout ;
    
    _repostLabel.width = cellBarLayout.toolbarRepostTextWidth;
    _commentLabel.width = cellBarLayout.toolbarCommentTextWidth;
    _likeLabel.width = cellBarLayout.toolbarLikeTextWidth;
    
    _repostLabel.textLayout = cellBarLayout.toolbarRepostTextLayout;
    _commentLabel.textLayout = cellBarLayout.toolbarCommentTextLayout;
    _likeLabel.textLayout = cellBarLayout.toolbarLikeTextLayout;
    
    [self adjustImage:_repostImageView label:_repostLabel inButton:_repostButton];
    [self adjustImage:_commentImageView label:_commentLabel inButton:_commentButton];
    [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
    
    _likeImageView.image =  [self unlikeImage] ;

}

- (UIImage *)likeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"timeline_icon_like"];
    });
    return img;
}

- (UIImage *)unlikeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"timeline_icon_unlike"];
    });
    return img;
}

- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button {
    CGFloat imageWidth = image.bounds.size.width;
    CGFloat labelWidth = label.width;
    CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid) / 2.0;
    image.centerX = paddingSide + imageWidth / 2;
    label.right = button.width - paddingSide;
}

- (void)likeBtnClick {
    self.isLiked = self.isLiked?NO:YES;
    BOOL liked = self.isLiked;
    
    UIImage *image = liked ? [self likeImage] : [self unlikeImage];
    int newCount = self.cellBarLayout.twitter.attitudes_count;
    newCount = liked ? newCount + 1 : newCount ;
    if (newCount < 0) newCount = 0;
    if (liked && newCount < 1) newCount = 1;
    NSString *newCountDesc = newCount > 0 ? [self.cellBarLayout setupBtnTitleWithCount:newCount] : @"赞";
    
    UIFont *font = [UIFont systemFontOfSize:userNameFont];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(TaoScreenWidth, toolBarHeight)];
    container.maximumNumberOfRows = 1;
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:newCountDesc];
    likeText.yy_font = font;
    likeText.yy_color = liked ? [UIColor nb_colorWithHex:0xdf422d] : [UIColor nb_colorWithHex:0x929292];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    

    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [_likeImageView.layer setValue:@(1.7) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        
        _likeImageView.image = image;
        _likeLabel.width = textLayout.textBoundingRect.size.width;
        _likeLabel.textLayout = textLayout;
        [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [_likeImageView.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [_likeImageView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

@end
