//
//  TaoAccountHeaderView.m
//  TaoTwitter
//
//  Created by wzt on 15/10/26.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoAccountHeaderView.h"
#define tableViewContenInset 10

@implementation TaoAccountHeaderView

+ (instancetype)taoAccountHeaderView {
    return [[[NSBundle mainBundle]loadNibNamed:@"TaoAccountHeaderView" owner:nil options:nil]firstObject];
}

- (void)awakeFromNib {
    self.width = TaoScreenWidth;
    self.height = tableViewContenInset;
    
}
@end
