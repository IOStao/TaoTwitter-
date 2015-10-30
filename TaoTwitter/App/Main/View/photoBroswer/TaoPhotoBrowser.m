//
//  TaoPhotoBrowser.m
//
//  Created by wzt on 15/10/22.
//  Copyright © 2015年 Baidu. All rights reserved.


#import "TaoPhotoBrowser.h"
#import "TaoPhotoView.h"
#import "MBProgressHUD.h"


#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface TaoPhotoBrowser () <TaoPhotoViewDelegate,MBProgressHUDDelegate> {
    MBProgressHUD *_HUD;
    UILabel  *_indexLabel;
    UIButton *_HDImageBtn;
    UIButton *_saveImageBtn;
    TaoPhotoView *_taoPhotoView;
    BOOL _statusBarHiddenInited;
	UIScrollView *_photoScrollView;
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
}
@end

@implementation TaoPhotoBrowser

#pragma mark - Lifecycle
- (void)loadView {
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self createToolbar];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar {
    CGFloat barHeight = 44;
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.frame = CGRectMake((TaoScreenWidth - 2 *barHeight)/2, barHeight, 80, 30);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _indexLabel = indexLabel;
    [self.view addSubview:_indexLabel];

    // 保存图片按钮
    UIButton *saveButton = [[UIButton alloc] init];
    saveButton.frame = CGRectMake(20, self.view.frame.size.height - barHeight, 50, 30);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveImageBtn = saveButton;
    [self.view addSubview:_saveImageBtn];
    
    // 原图片按钮
    UIButton *hdImageBtn = [[UIButton alloc] init];
    hdImageBtn.frame = CGRectMake(CGRectGetMaxX(_saveImageBtn.frame)+30, self.view.frame.size.height - barHeight, 50, 30);
    [hdImageBtn setTitle:@"原图" forState:UIControlStateNormal];
    [hdImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hdImageBtn.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    hdImageBtn.layer.cornerRadius = 5;
    hdImageBtn.clipsToBounds = YES;
    [hdImageBtn addTarget:self action:@selector(hdImage) forControlEvents:UIControlEventTouchUpInside];
    _HDImageBtn = hdImageBtn;
    [self.view addSubview:_HDImageBtn];
    
     _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
}

#pragma mark 创建UIScrollView
- (void)createScrollView {
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    for (int i = 0; i<_photos.count; i++) {
        TaoPhotoModel *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex {
    _currentPhotoIndex = currentPhotoIndex;
    for (int i = 0; i<_photos.count; i++) {
        TaoPhotoModel *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - TaoPhotoView代理
- (void)photoViewSingleTap:(TaoPhotoView *)photoView {
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
    [_indexLabel removeFromSuperview];
    [_saveImageBtn removeFromSuperview];
    [_HDImageBtn removeFromSuperview];
}

- (void)photoViewDidEndZoom:(TaoPhotoView *)photoView {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark 显示照片
- (void)showPhotos {
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    CGRect visibleBounds = _photoScrollView.bounds;
	NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (TaoPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSInteger)index {
    TaoPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[TaoPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    TaoPhotoModel *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    _taoPhotoView = photoView;
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSInteger)index {
    if (index > 0) {
        TaoPhotoModel *photo = _photos[index - 1];
        [[SDWebImageManager sharedManager]downloadImageWithURL:photo.url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        }];
    }
    if (index < _photos.count - 1) {
        TaoPhotoModel *photo = _photos[index + 1];
        [[SDWebImageManager sharedManager]downloadImageWithURL:photo.url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        }];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (TaoPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (TaoPhotoView *)dequeueReusablePhotoView {
    TaoPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
    _currentPhotoIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
}

- (void)saveImage {
    TaoPhotoModel *photo = _photos[_currentPhotoIndex];
    if (photo.save) {
        _HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication].windows lastObject]];
        [self.view addSubview:_HUD];
        [self.view addSubview:_HUD];
        _HUD.mode = MBProgressHUDModeText;
        _HUD.delegate = self;
        _HUD.labelText = @"已经保存";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
            }else {
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        _HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication].windows lastObject]];
        [self.view addSubview:_HUD];
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red-x"]];
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.delegate = self;
        _HUD.labelText = @"保存失败";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        
    } else {
        TaoPhotoModel *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _HUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication].windows lastObject]];
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.delegate = self;
        _HUD.labelText = @"保存成功";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];

    }
}

- (void)hdImage {
    [TaoNotificationCenter postNotificationName:TaoPhotoBrowserChangeHDImage object:nil];
}

@end