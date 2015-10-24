//
//  TaoSearverAPI.h
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TaoSearverAPI : JSONModel
@end

@class TaoUser;
@interface TaoAccountItem : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) TaoUser *user;

@end

@interface TaoUser : TaoSearverAPI
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *avatar_hd;

@end
