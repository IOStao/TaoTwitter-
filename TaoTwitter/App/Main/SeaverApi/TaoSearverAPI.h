//
//  TaoSearverAPI.h
//  TaoTwitter
//
//  Created by wzt on 15/10/23.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
typedef enum {
    TaoUserVerifiedTypeNone               = -1, // 没有任何认证
    TaoUserVerifiedPersonal               = 0,  // 个人认证
    TaoUserVerifiedOrgEnterprice          = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    TaoUserVerifiedOrgMedia               = 3, // 媒体官方：程序员杂志、苹果汇
    TaoUserVerifiedOrgWebsite             = 5, // 网站官方：猫扑
    TaoUserVerifiedDaren                  = 220 // 微博达人
} TaoUserVerifiedType;

typedef enum : NSUInteger {
    textNormole      = -1,
    urlTypeWeb       = 0,
    urlTypeVideo     = 1,
    urlTypeMusic     = 2,
    urlTypeActivity  = 3,
    urlTypeVote      = 5,
    textTypeAt         = 6,
    textTypeTopic      = 7,
    textTypeEmotion    = 8,

} urlType;

@protocol Taostatus @end
@protocol Taocomment@end
@protocol Taotype   @end


@interface TaoSearverAPI : JSONModel<NSCoding>
@end


@class Taousers;
@interface TaoAccountItem : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) Taousers *user;
@end



@interface Taousers : TaoSearverAPI
@property (nonatomic, strong) NSString *screen_name;
/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;
/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;
/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *avatar_hd;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;

@property (nonatomic, assign, getter = isVip) BOOL vip;
/** 认证类型 */
@property (nonatomic, assign) TaoUserVerifiedType verified_type;
@end



@interface Taostatuses : TaoSearverAPI
@property (nonatomic, strong) NSArray<Taostatus,Optional> *statuses;
/** 转发总数 */
@property (nonatomic, assign) int total_number;
@end



@interface Taostatus : TaoSearverAPI
/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;
/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;
/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) Taousers *user;
/**	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;
/**	string	微博来源*/
@property (nonatomic, copy) NSString *source;
/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;
/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) Taostatus *retweeted_status;
/**	int	转发数*/
@property (nonatomic, assign) int reposts_count;
/**	int	评论数*/
@property (nonatomic, assign) int comments_count;
/**	int	表态数*/
@property (nonatomic, assign) int attitudes_count;
@property (nonatomic, strong) NSString *bmiddle_pic;
@property (nonatomic, strong) NSString *original_pic;
@property (nonatomic,  copy) NSString *pic_bg;
@end



@interface TaoPhoto : TaoSearverAPI
@property (nonatomic, strong) NSString *thumbnail_pic;
@end



@interface Taocomments : TaoSearverAPI
/** 评论数组 */
@property (nonatomic, strong) NSArray<Taocomment> *comments;
/** 评论总数 */
@property (nonatomic, assign) int total_number;
@end



@interface Taocomment : TaoSearverAPI
/** 	string 	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;
/** 	string 	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;
/** 	string 	微博信息内容*/
@property (nonatomic, copy) NSString *text;
/** 	string 	微博来源*/
@property (nonatomic, copy) NSString *source;
/** 	object 	评论作者的用户信息字段 详细*/
@property (nonatomic, strong) Taousers *user;
/** 	object	评论的微博信息字段 详细*/
@property (nonatomic, strong) Taostatus *status;

@end



@interface Taoreposts : TaoSearverAPI
@property (nonatomic, strong) NSArray<Taostatus,Optional
> *reposts;
@property (nonatomic, assign) int total_number;

@end


@interface Taourls : TaoSearverAPI
@property (nonatomic, strong) NSArray<Taotype> *urls;
@end

@interface taoType : TaoSearverAPI
@property (nonatomic, assign) urlType   type;
@end