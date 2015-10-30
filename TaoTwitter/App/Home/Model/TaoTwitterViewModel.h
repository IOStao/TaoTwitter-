//
//  TaoTwitterViewModel.h
//  TaoTwitter
//
//  Created by wzt on 15/10/25.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoTwitterViewModel : NSObject
- (void)loaddata;
@property (nonatomic, strong) TaoTwitter *status;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end
