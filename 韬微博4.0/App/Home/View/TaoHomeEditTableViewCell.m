//
//  TaoHomeEditTableViewCell.m
//  韬微博4.0
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoHomeEditTableViewCell.h"

@implementation TaoHomeEditTableViewCell

- (void)awakeFromNib {
    // Initialization code0
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    backgroundView.backgroundColor = [UIColor tao_homeEditCellColor];
    self.selectedBackgroundView = backgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
