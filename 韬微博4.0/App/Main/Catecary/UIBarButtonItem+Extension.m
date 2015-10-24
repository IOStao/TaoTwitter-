//
//  UIBarButtonItem+Extension.m
//  
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action type:(TaoNavBarButtonType)type title:(NSString *)title {
     UIBarButtonItem *resultButtonItem = nil;
    
    switch (type) {
            
        case TaoNavBarButtonTypeBack:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:@"navigationbar_back_withtext" highImage:@"navigationbar_back_withtext_highlighted"title:title];
            break;
        case TaoNavBarButtonTypeTextButton:
            break;
        case TaoNavBarButtonTypeCancel:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:nil highImage:nil title:@"取消"];
            break;
        case TaoNavBarButtonTypeTextSubmitButton:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:nil highImage:nil title:@"发送"];
            break;
        case TaoNavBarButtonTypeIconShare:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"title:nil];
            break;
        case TaoNavBarButtonTypeIconMessage:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:@"" highImage:@"" title:nil];
            break;
        case TaoNavBarButtonTypeCustom:
            break;
        case TaoNavBarButtonTypeIconSetting:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:nil highImage:nil title:@"设置"];
            break;
        case TaoNavBarButtonTypeIconRadar:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:@"navigationbar_icon_radar"highImage:@"navigationbar_icon_radar_highlighted" title:nil];
            break;
        case TaoNavBarButtonTypeIconFriend:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:@"navigationbar_friendattention" highImage:@"navigationbar_friendattention_highlighted" title:nil];
            break;
        case TaoNavBarButtonTypeInsert:
            resultButtonItem = [UIBarButtonItem itemWithTarget:target action:action image:nil highImage:nil title:title];
            break;
        default:
            break;
    }
    resultButtonItem.tag = type;
    return resultButtonItem;
}
/**
 *  创建一个item
 *  
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
        // 设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.size = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font];
    // 设置图片
    if (nil != image ) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
        // 设置尺寸
        btn.size = btn.currentImage.size;
        if (nil != title) {
            btn.size = CGSizeMake(btn.currentImage.size.width + [btn.titleLabel.text sizeWithFont:btn.titleLabel.font].width, btn.currentImage.size.height);
        }
    }
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
