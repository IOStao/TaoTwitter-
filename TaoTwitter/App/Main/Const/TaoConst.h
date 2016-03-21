//
//  TaoConst.h
//  TaoTwitter
//
//  Created by wzt on 15/10/21.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 账号信息
extern NSString * const TaoAppKey;
extern NSString * const TaoRedirectURI;
extern NSString * const TaoAppSecret;
extern NSString * const TaoAccountSSOSuccessNotification;
extern NSString * const TaoAccountLogin;
extern NSString * const TaoAccountLogout;

// 通知
// 表情选中的通知
extern NSString * const TaoEmotionDidSelectNotification;
extern NSString * const TaoSelectEmotionKey;
extern NSString * const TaoComposeEmotionListViewDidScrollNotification;

// 删除文字的通知
extern NSString * const TaoEmotionDidDeleteNotification;
//HomeTitle
extern NSString * const TaoHomeTitleWindowRemoveNotification;
extern NSString * const TaoHomeTitleMenuEditBtnNotification;
//signaltag
extern NSInteger const  TaoHomeEditTableViewCellImageTapTag;
//更换大图
extern NSString * const TaoPhotoBrowserChangeHDImage;