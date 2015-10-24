//
//  TaoSearverAPI.h
//  韬微博4.0
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class TaoAccountItem;
@interface TaoSearverAPI : JSONModel
@end

@protocol TaoAccountItem @end

@interface TaoAccountItems : NSObject<NSCoding>

@property (nonatomic, strong) NSMutableArray<TaoAccountItem> *items;
@end


@interface TaoAccountItem : NSObject<NSCoding>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;
@end

@interface TaoUser : TaoSearverAPI
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *avatar_large;
@property (nonatomic, strong) NSString *avatar_hd;
@property (nonatomic, assign) NSInteger  followers_count;
@property (nonatomic, assign) NSInteger  statuses_count;
@property (nonatomic, assign) NSInteger  favourites_count;
@end
