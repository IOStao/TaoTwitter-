//
//  NSURLSessionDownloadTask+Resume.m
//  mybaby
//
//  Created by JiangYan on 15/7/29.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "NSURLSessionDownloadTask+Resume.h"
#import <objc/runtime.h>

@implementation NSURLSessionDownloadTask(Resume)

- (BOOL)kid_allowResume{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKid_allowResume:(BOOL)allowResume{
    objc_setAssociatedObject(self, @selector(kid_allowResume), @(allowResume), OBJC_ASSOCIATION_RETAIN);
}

+ (void)addKid_allowResume:(id)object{
    IMP imp = class_getMethodImplementation(self, @selector(kid_allowResume));
    const char * types = method_getTypeEncoding(class_getInstanceMethod(self, @selector(kid_allowResume)));
    class_replaceMethod([object class], @selector(kid_allowResume),imp , types);
    imp = class_getMethodImplementation(self, @selector(setKid_allowResume:));
    types = method_getTypeEncoding(class_getInstanceMethod(self, @selector(setKid_allowResume:)));
    class_replaceMethod([object class], @selector(setKid_allowResume:), imp, types);
}

+ (NSData *)resumeDataWithLastResumePlistData:(NSData *)lastResumData{
    if (!lastResumData) {
        return nil;
    }
    
    NSError *error = nil;
    NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
    NSMutableDictionary *lastDownloadTaskResumeInfo = [NSPropertyListSerialization propertyListWithData:lastResumData options:NSPropertyListMutableContainers format:&format error:&error];
    if (error || !lastDownloadTaskResumeInfo) {
        return nil;
    }
    NSString *lastDownloadTaskLocalTmpFile = lastDownloadTaskResumeInfo[@"NSURLSessionResumeInfoLocalPath"];
    NSArray  *lastDownloadTaskPaths        = [lastDownloadTaskLocalTmpFile componentsSeparatedByString:@"/tmp/"];
    if (2 != lastDownloadTaskPaths.count) {
        return nil;
    }
    NSString * lastDownloadTaskHomeDirectory    = lastDownloadTaskPaths[0];
    NSString * currentDownloadTaskHomeDirectory = NSHomeDirectory();
    //如果当前的文件系统路径与上一次请求是一致的，则这个resumedata是可用的
    if ([lastDownloadTaskHomeDirectory isEqualToString:currentDownloadTaskHomeDirectory]) {
        return lastResumData;
    }else{
        //将上次请求产生的resumedata 中的临时文件路径变成当前路径，因为每次App启动，App的逻辑路径基本上都会改变。
        NSString * currentTmpPath = [[currentDownloadTaskHomeDirectory stringByAppendingString:@"/tmp/"] stringByAppendingString:lastDownloadTaskPaths[1]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:currentTmpPath]) {
            return nil;
        }
                                     
         lastDownloadTaskResumeInfo[@"NSURLSessionResumeInfoLocalPath"] = [[currentDownloadTaskHomeDirectory stringByAppendingString:@"/tmp/"] stringByAppendingString:lastDownloadTaskPaths[1]];
        NSData * resumeDownloadData = [NSPropertyListSerialization dataWithPropertyList:lastDownloadTaskResumeInfo format:NSPropertyListXMLFormat_v1_0 options:0 error:nil ];
        return resumeDownloadData;
    }
    return nil;
}

@end
