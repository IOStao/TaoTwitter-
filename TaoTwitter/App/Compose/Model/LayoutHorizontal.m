//
//  LayoutHorizontal.m
//  UILayoutHorizontal
//
//  Created by wzt on 15/11/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "LayoutHorizontal.h"

@interface LayoutHorizontal()
@property (nonatomic, strong) NSMutableArray *attrbutarray;
@end

@implementation LayoutHorizontal

- (NSMutableArray *)attrbutarray {
    if (!_attrbutarray) {
        _attrbutarray = [NSMutableArray array];
    }
    return _attrbutarray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat sectionWidth = 0;
    for (int i = 1 ; i <= indexPath.section; i ++) {
        NSInteger maxCount = ceil((float)[self.collectionView numberOfItemsInSection:i - 1] / (self.totalColum *self.totalRow));
        sectionWidth  += [UIScreen mainScreen].bounds.size.width * maxCount;
    }
    CGFloat baseWidth =  sectionWidth + indexPath.item / (self.totalColum *self.totalRow) * [UIScreen mainScreen].bounds.size.width;
    CGFloat marginX = self.minimumInteritemSpacing;
    
    CGFloat X = baseWidth + self.sectionInset.left + (indexPath.item % self.totalColum)* (self.itemSize.width + marginX);
    CGFloat Y = self.sectionInset.top + ((indexPath.item %(self.totalColum *self.totalRow))/ self.totalColum) * (self.itemSize.height + self.minimumInteritemSpacing);
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(X, Y, self.itemSize.width, self.itemSize.height);
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    [self.attrbutarray removeAllObjects];
    NSInteger sections = [self.collectionView numberOfSections];
    for (int i = 0 ; i < sections; i ++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < count; j ++) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:index];
            [self.attrbutarray addObject:attr];
        }
    }

    return self.attrbutarray;
}


- (CGSize)collectionViewContentSize {
    CGFloat Width  ;
    for (int i = 0 ; i < [self.collectionView numberOfSections]; i ++) {
        NSInteger maxCount = ceil((float)[self.collectionView numberOfItemsInSection:i] / (self.totalColum *self.totalRow));
        Width  += [UIScreen mainScreen].bounds.size.width * maxCount ;
    }
    CGFloat Height =  self.sectionInset.top + self.sectionInset.bottom + self.itemSize.height * (self.totalRow) + (self.totalRow - 1)* self.minimumInteritemSpacing;
    return CGSizeMake(Width , Height);
   
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    if (self.collectionView.contentOffset.x < CGRectGetWidth(newBounds)) {
        return NO;
    }
    return YES;
}
@end
