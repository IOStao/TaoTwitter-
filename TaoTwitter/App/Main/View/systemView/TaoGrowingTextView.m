//
//  TaoGrowingTextView.m
//  TaoTwitter
//
//  Created by wzt on 15/12/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoGrowingTextView.h"

@interface TaoGrowingTextView ()

@property(nonatomic) UILabel *placeholderLabel;
@property(nonatomic, readonly) NSLayoutConstraint *heightConstraint;

@end

@implementation TaoGrowingTextView

+ (NSArray *)observingKeys {
    return @[@"font", @"text", @"attributedText", @"frame", @"textAlignment", @"textContainerInset", @"bounds"];
}

- (void)dealloc {
    if (_placeholderLabel) {
        for (NSString *key in self.class.observingKeys) {
            [self removeObserver:self forKeyPath:key];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [UIColor tao_placeholderColor];
        _placeholderLabel.numberOfLines = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceholder) name:UITextViewTextDidChangeNotification object:self];
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return _placeholderLabel;
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

- (NSLayoutConstraint *)heightConstraint {
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && !constraint.secondItem) {
            return constraint;
        }
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    constraint.priority = UILayoutPriorityDefaultHigh;
    [self addConstraint:constraint];
    return constraint;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.contentSize.height;
    if (self.minHeight) {
        height = MAX(height, self.minHeight);
    }
    if (self.maxHeight) {
        height = MIN(height, self.maxHeight);
    }
    self.heightConstraint.constant = height;
    if (height >= self.contentSize.height) {
        self.contentOffset = CGPointZero;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updatePlaceholder];
}

- (void)updatePlaceholder {
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    
    [self insertSubview:self.placeholderLabel atIndex:0];
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.textAlignment = self.textAlignment;
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    CGFloat x = lineFragmentPadding + self.textContainerInset.left;
    CGFloat y = self.textContainerInset.top;
    self.placeholderLabel.frame = CGRectMake(x, y, self.bounds.size.width - x - lineFragmentPadding - self.textContainerInset.right, 0);
    [self.placeholderLabel sizeToFit];
}



@end
