//
//  NSURLSessionDownloadTask+Resume.h
//  mybaby
//
//  Created by JiangYan on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionDownloadTask(Resume)
@property(nonatomic, assign) BOOL kid_allowResume;
+ (NSData *)resumeDataWithLastResumePlistData:(NSData *)lastResumData;
+ (void)addKid_allowResume:(id)object;
@end
