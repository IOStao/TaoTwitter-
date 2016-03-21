//
//  TaoComposeTextViewManager.m
//  TaoTwitter
//
//  Created by wzt on 15/12/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeTextViewManager.h"
#import "TaoComposeTextLableRegexKitLiteTool.h"
#import "UITextView+TaoTextView.h"

@interface TaoComposeTextViewManager ()<UITextViewDelegate>
@property(nonatomic,strong) UIViewController *parentViewController;
@property (weak, nonatomic) IBOutlet UIScrollView *Container;

@end

@implementation TaoComposeTextViewManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)p_keyboardChangeFrame:(NSNotification *)noti {
    CGRect keyboardEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewController *vc = self.parentViewController;
    
    if (!vc) {
        if ([self.inputBarBottomConstraint.firstItem isKindOfClass:[UIView class]]) {
            vc = [(UIView *)self.inputBarBottomConstraint.firstItem tao_parentViewController];
        } else if ([self.inputBarBottomConstraint.secondItem isKindOfClass:[UIView class]]) {
            vc = [(UIView *)self.inputBarBottomConstraint.secondItem tao_parentViewController];
        }
    }
    
    [vc.view layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.inputBarBottomConstraint.constant = MAX(TaoScreenHeight - keyboardEndFrame.origin.y, 0);
        [vc.view layoutIfNeeded];
    } completion:nil];
}

- (void)p_keyboardHide:(NSNotification *)noti {
    UIViewAnimationCurve curve = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewController *vc = self.parentViewController;
    
    if (!vc) {
        if ([self.inputBarBottomConstraint.firstItem isKindOfClass:[UIView class]]) {
            vc = [(UIView *)self.inputBarBottomConstraint.firstItem tao_parentViewController];
        } else if ([self.inputBarBottomConstraint.secondItem isKindOfClass:[UIView class]]) {
            vc = [(UIView *)self.inputBarBottomConstraint.secondItem tao_parentViewController];
        }
    }
    
    [vc.view layoutIfNeeded];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.inputBarBottomConstraint.constant = 0;
        [vc.view layoutIfNeeded];
    } completion:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.Container.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    textView.attributedText =[[TaoComposeTextLableRegexKitLiteTool shared]attributedTextWithText:textView.text attributedText:textView.attributedText font:textView.font];
    [self adjustTextViewSelectRangePositionWithTextView:textView];
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self adjustTextViewSelectRangePositionWithTextView:textView];
        
    });
}

- (void)adjustTextViewSelectRangePositionWithTextView:(UITextView *)textView {
    UITextRange *range = textView.selectedTextRange;
    CGRect rect = [textView caretRectForPosition:range.start];
//这个破算法 脑仁都烂了  下面的 contentInset
    if ( 64 + textView.y + CGRectGetMaxY(rect) - self.Container.contentOffset.y >= self.inputView.y - 20) {
        [UIView animateWithDuration:0.3f animations:^{
            self.Container.contentOffset = CGPointMake(0,  (64 + textView.y + CGRectGetMaxY(rect) - self.inputView.y + 20));
            self.Container.contentInset = UIEdgeInsetsMake(0, 0, self.inputView.y, 0);
        }];
    }   
}


@end
