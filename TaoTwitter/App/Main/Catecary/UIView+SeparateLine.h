//
//  UIView+SeparateLine.h
//  mybaby
//
//  Created by JiangYan on 15/11/26.
//  Copyright © 2015年 Baidu. All rights reserved.
//

typedef NS_OPTIONS(NSInteger, TaoViewSeparateType) {
    TaoViewSeparateTypeTop       = 1<<0,
    TaoViewSeparateTypeLeft      = 1<<1,
    TaoViewSeparateTypeBottom    = 1<<2,
    TaoViewSeparateTypeRight     = 1<<3,
    TaoSeparateTypeAll           = TaoViewSeparateTypeTop|
                                  TaoViewSeparateTypeLeft|
                                  TaoViewSeparateTypeBottom|
                                  TaoViewSeparateTypeRight
};

@interface UIView (SeparateLine)
@property(nonatomic, assign)TaoViewSeparateType showSeparateLineType;
@property(nonatomic, assign)TaoViewSeparateType hiddenSeparateLineType;

@property(nonatomic, assign)UIEdgeInsets       topSeparateLineEdegeInset;
@property(nonatomic, assign)UIEdgeInsets       leftSeparateLineEdegeInset;
@property(nonatomic, assign)UIEdgeInsets       bottomSeparateLineEdegeInset;
@property(nonatomic, assign)UIEdgeInsets       rightSeparateLineEdegeInset;

@property(nonatomic, assign)UIColor            *topSeparateLineColor;
@property(nonatomic, assign)UIColor            *leftSeparateLineColor;
@property(nonatomic, assign)UIColor            *bottomSeparateLineColor;
@property(nonatomic, assign)UIColor            *rightSeparateLineColor;

@property(nonatomic, assign)CGFloat           topSeparateLineHeight;
@property(nonatomic, assign)CGFloat           bottomSeparateLineHeight;
@property(nonatomic, assign)CGFloat           leftSeparateLineHeight;
@property(nonatomic, assign)CGFloat           rightSeparateLineHeight;

@property(nonatomic, strong, readonly) NSMutableDictionary *extraPropertys;
- (NSMutableDictionary *)extraPropertys ;
@end
