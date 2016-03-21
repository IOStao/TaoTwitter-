//
//  TaoComposeEmotionCell.m
//  TaoTwitter
//
//  Created by wzt on 15/11/19.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeEmotionCell.h"
#import "TaoComposeEmotionModel.h"
#import <YYWebImage/YYWebImage.h>

@interface  TaoComposeEmotionCell()
@property(nonatomic, strong) UIImageView *emotionImage;
@property(nonatomic, strong) UILabel *emotionLable;
@property(nonatomic, strong) UIButton *deleteBtn;
@property (strong,nonatomic) NSTimer *timer;
@end

@implementation TaoComposeEmotionCell
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = self.bounds;
        [_deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteReapte:)]];
    }
    return _deleteBtn;
}

- (UIImageView *)emotionImage {
    if (!_emotionImage) {
        _emotionImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _emotionImage.contentMode = UIViewContentModeCenter;
        _emotionImage.userInteractionEnabled = YES;
        [_emotionImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emotionClick)]];
    }
    return _emotionImage;
}

- (UILabel *)emotionLable {
    if (!_emotionLable) {
        _emotionLable = [[UILabel alloc] initWithFrame:self.bounds];
        _emotionLable.font = [UIFont systemFontOfSize:32];
        _emotionLable.userInteractionEnabled = YES;
        [_emotionLable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emotionClick)]];
        _emotionLable.textAlignment = NSTextAlignmentCenter;
    }
    return _emotionLable;
}

- (void)setEmotion:(TaoComposeEmotionModel *)emotion {
    _emotion = emotion;
    
    if (_emotion.png) {
        [self.deleteBtn removeFromSuperview];
        [self.emotionLable removeFromSuperview];
        [self.contentView addSubview:self.emotionImage];
        NSString *filename = _emotion.png;
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:filename ofType:nil];
        [self.emotionImage yy_setImageWithURL:[NSURL fileURLWithPath:path]placeholder:nil];
        
        
    }else if (_emotion.code) {
        [self.emotionImage removeFromSuperview];
        [self.deleteBtn removeFromSuperview];
        [self.contentView addSubview:self.emotionLable];
        self.emotionLable.text = emotion.code.emoji;
        
    }else if (_emotion.emotionDelete ) {
        [self.emotionLable removeFromSuperview];
        [self.emotionImage removeFromSuperview];
        [self.contentView addSubview:self.deleteBtn];
        
    }else if (_emotion.isNotEmotion) {
        [self.emotionImage removeFromSuperview];
        [self.emotionLable removeFromSuperview];
        [self.deleteBtn removeFromSuperview];
    }
}


- (void)deleteClick {
    [TaoNotificationCenter postNotificationName:TaoEmotionDidDeleteNotification object:nil];
}

- (void)emotionClick {
    if ([self.delegate respondsToSelector:@selector(TaoComposeEmotionCellEmotionBtnClickWithEmotionCell:)]) {
        [self.delegate TaoComposeEmotionCellEmotionBtnClickWithEmotionCell:self];
    }
}

- (void)deleteReapte:(UIGestureRecognizer *)gesture {

    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            [self startTimer];
            break;
        
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            [self endTimer];
            break;
        }
        default:
           
            break;
    }
}

- (void)startTimer {
    [self endTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteClick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)endTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startTimer) object:nil];
    [self.timer invalidate];
    self.timer = nil;

}
@end
