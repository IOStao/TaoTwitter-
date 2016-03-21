//
//  TaoComposeEmotionListViewPopView.m
//  TaoTwitter
//
//  Created by wzt on 15/11/21.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeEmotionListViewPopView.h"
#import "TaoComposeEmotionCell.h"
#import "TaoComposeEmotionModel.h"
#import <pop/POP.h>

@interface TaoComposeEmotionListViewPopView ()
@property (nonatomic, weak) TaoComposeEmotionCell *emotionCell;
@end

@implementation TaoComposeEmotionListViewPopView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configerSubViews];
    }
    return self;
}

- (void)configerSubViews {
    UIImageView *popImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
    self.size = popImage.size;
    popImage.origin = CGPointMake(0, 0);
    [self addSubview:popImage];
    
    TaoComposeEmotionCell *cell = [[TaoComposeEmotionCell alloc] init];
    [self addSubview:cell];
    self.emotionCell = cell;
}

- (void)showFromTaoComposeEmotionCell:(TaoComposeEmotionCell *)cell {
    if (cell.emotion.emotionDelete ||cell.emotion.isNotEmotion || cell == nil || [cell.emotion isEqual:self.emotionCell.emotion]) return;
    self.emotionCell.transform = CGAffineTransformIdentity;
    self.emotionCell.size = CGSizeMake(self.width, self.width);
    self.emotionCell.origin = CGPointMake(0, cell.height);
    self.emotionCell.transform = CGAffineTransformScale(self.emotionCell.transform, 1.2, 1.2);
    self.emotionCell.emotion = cell.emotion;
    
    CGRect btnFrame = [cell convertRect:cell.bounds toView:nil];
    self.y = CGRectGetMaxY(btnFrame) - self.height - 4;
    self.centerX = CGRectGetMidX(btnFrame);
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.springSpeed = 5;
    springAnimation.springBounciness = 15;
    springAnimation.fromValue = @(self.width/2);
    springAnimation.toValue = @(cell.height/2);
    
    [self.emotionCell.layer pop_addAnimation:springAnimation forKey:@"PopWithPosition"];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
}

- (void)didMoveToSuperview {
    self.emotionCell.emotion = nil;
}
@end
