//
//  TaoComposeKeyBoardToolBar.m
//  TaoTwitter
//
//  Created by wzt on 15/12/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeKeyBoardToolBar.h"

@interface TaoComposeKeyBoardToolBar()
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *Public;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property(nonatomic, weak) IBOutlet UIButton *emotionBtn;
@end

@implementation TaoComposeKeyBoardToolBar


- (void)awakeFromNib {
    self.toolBar.showSeparateLineType = TaoViewSeparateTypeTop | TaoViewSeparateTypeBottom;
    
    [self.locationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor nb_colorWithHex:0xf8f8f8] cornerRadius:self.locationBtn.height/2 borderColor:[UIColor nb_colorWithHex:0xe4e4e4] borderWidth:1] forState:UIControlStateNormal];
    [self.locationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor nb_colorWithHex:0xe0e0e0] cornerRadius:self.locationBtn.height/2 borderColor:[UIColor nb_colorWithHex:0xe4e4e4] borderWidth:1] forState:UIControlStateHighlighted];
    
    
    [self.Public setBackgroundImage:[UIImage imageWithColor:[UIColor nb_colorWithHex:0xf8f8f8] cornerRadius:self.locationBtn.height/2 borderColor:[UIColor nb_colorWithHex:0xe4e4e4] borderWidth:1] forState:UIControlStateNormal];
    [self.Public setBackgroundImage:[UIImage imageWithColor:[UIColor nb_colorWithHex:0xe0e0e0] cornerRadius:self.locationBtn.height/2 borderColor:[UIColor nb_colorWithHex:0xe4e4e4] borderWidth:1] forState:UIControlStateHighlighted];
    
}

- (IBAction)toolBarClick:(UIButton *)sender {
    TaoComposeToolbarButtonType type = (TaoComposeToolbarButtonType)sender.tag;
    if ([self.delegate respondsToSelector:@selector(TaoComposeKeyBoardToolBarBtnClickWithTaoComposeKeyBoardToolBar:type:)]) {
        [self.delegate TaoComposeKeyBoardToolBarBtnClickWithTaoComposeKeyBoardToolBar:self type:type];
    }
}

- (void)setShowKeyboardButton:(BOOL)showKeyboardButton {
    _showKeyboardButton = showKeyboardButton;
    
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    [self.emotionBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionBtn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];

}

@end
