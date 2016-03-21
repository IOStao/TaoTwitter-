//
//  TaoTwitterRStatusView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/2.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoTwitterRStatusView.h"
#import "TaoStatusPhotosView.h"
#import "TaoTwitterTextLable.h"
#import "TaoRStatuesViewLayout.h"

@interface  TaoTwitterRStatusView()
@property (strong, nonatomic)  TaoTwitterTextLable *rStatues;
@property (nonatomic, strong)  UIView *leftLine;
@property (strong, nonatomic)  TaoStatusPhotosView *rphotosView;
@end

@implementation TaoTwitterRStatusView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configerSubviews];
    }
    return self;
}

- (void)configerSubviews {
   self.leftLine  = [[UIView alloc] init];
   self.leftLine.backgroundColor = [UIColor lightGrayColor];
   [self addSubview:self.leftLine];
   
   self.rStatues = [[TaoTwitterTextLable alloc] init];
    [self addSubview:self.rStatues];
    
   self.rphotosView = [[TaoStatusPhotosView alloc] init];
    [self addSubview:self.rphotosView];
}

- (void)setRStatuesViewLayout:(TaoRStatuesViewLayout *)rStatuesViewLayout {
    _rStatuesViewLayout = rStatuesViewLayout;
    
    self.leftLine.frame = rStatuesViewLayout.leftLineFrame;
    
    self.rStatues.frame = rStatuesViewLayout.rStatuesFrame;
    self.rStatues.textLayout = rStatuesViewLayout.rStatuesLayout;

    if (!CGRectEqualToRect(CGRectZero, rStatuesViewLayout.rphotosViewFrame)) {
        self.rphotosView.hidden = NO;
        self.rphotosView.pictureLayout = rStatuesViewLayout.rPictureLayout;
            } else {
        self.rphotosView.hidden = YES;
    }
     self.rphotosView.frame = rStatuesViewLayout.rphotosViewFrame;

}

@end


//#import "TaoTwitterRStatusView.h"
//#import "TaoStatusPhotosView.h"
//#import <Masonry.h>
//#import "TaoTwitterTextLable.h"
//
//@interface  TaoTwitterRStatusView()
//@property (strong, nonatomic)  TaoTwitterTextLable *rStatues;
//@property (nonatomic, strong)  UIView *leftLine;
//@property (strong, nonatomic)  TaoStatusPhotosView *rphotosView;
//@end
//
//@implementation TaoTwitterRStatusView
//- (UIView *)leftLine {
//    if (!_leftLine) {
//       self.leftLine  = [[UIView alloc] init];
//       self.leftLine.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:_leftLine];
//        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(10));
//            make.width.equalTo(@(10));
//            make.top.equalTo(self.rStatues.mas_top);
//            make.bottom.equalTo(self.rStatues.mas_bottom);
//        }];
//    }
//    return _leftLine;
//}
//
//- (TaoTwitterTextLable *)rStatues {
//    if (!_rStatues) {
//       self.rStatues = [[TaoTwitterTextLable alloc] init];
//       self.rStatues.numberOfLines = 0;
//       self.rStatues.font = [UIFont systemFontOfSize:16];
//       self.rStatues.textColor = [UIColor tao_textLableColor];
//        [self addSubview:_rStatues];
//        [_rStatues mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(0));
//            make.left.equalTo(self.leftLine.mas_right).offset(5);
//            make.right.equalTo(@(-10));
//        }];
//    }
//    return _rStatues;
//}
//
//- (TaoStatusPhotosView *)rphotosView {
//    if (!_rphotosView) {
//       self.rphotosView = [[TaoStatusPhotosView alloc] init];
//        [self addSubview:_rphotosView];
//    }
//    return _rphotosView;
//}
//
//- (void)setTwitter:(Taostatus *)twitter {
//   _twitter = twitter;
//    
//    NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", twitter.user.name, twitter.text];
//    self.rStatues.attributedText = [_rStatues attributedTextWithText:retweetContent];
//        
//    if (twitter.pic_urls.count) {
//        self.rphotosView.hidden = NO;
//        self.rphotosView.photos = twitter.pic_urls;
//        CGSize size = [TaoStatusPhotosView sizeWithCount:twitter.pic_urls.count];
//        [self.rphotosView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(10));
//            make.top.equalTo(self.rStatues.mas_bottom).offset(10).priorityHigh();
//            make.bottom.equalTo(@(0));
//            make.height.equalTo(@(size.height)).priorityHigh();
//            make.width.equalTo(@(size.width));
//        }];
//        } else {
//         self.rphotosView.hidden = YES;
//         [self.rphotosView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(10));
//            make.bottom.equalTo(@(0));
//            make.top.equalTo(self.rStatues.mas_bottom).offset(0);
//            make.height.equalTo(@(0)).priorityHigh();
//         }];
//        }
//}
//
//@end
