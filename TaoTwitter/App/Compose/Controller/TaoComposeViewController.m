//
//  TaoComposeViewController.m
//  TaoTwitter
//
//  Created by wzt on 15/11/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoComposeViewController.h"
#import "TaoComposeKeyBoardInputView.h"
#import "LayoutHorizontal.h"
#import "TaoComposeTextView.h"
#import "TaoComposePictureViewModel.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "TaoComposeKeyBoardToolBar.h"

//NSString *const 

@interface TaoComposeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TaoComposeKeyBoardToolBarDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet LayoutHorizontal *layout;
@property (weak, nonatomic) IBOutlet TaoComposeTextView *composeTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureCollectionView;
@property (weak, nonatomic) IBOutlet TaoComposeKeyBoardToolBar *keyBoardToolBar;
@property (nonatomic, strong) TaoComposePictureViewModel *viewModel;
@property (nonatomic, strong) TaoComposeKeyBoardInputView *emotionKeyboard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureCollectionViewHeight;


@end

@implementation TaoComposeViewController

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Compose" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"TaoComposeViewController"];
    }
    return self; 
}

- (void)configureSelf {
    _viewModel = [[TaoComposePictureViewModel alloc] init];
    self.navBarConfig.leftButtonType = TaoNavBarButtonTypeCancel;
    self.navBarConfig.rightButtonType = TaoNavBarButtonTypeTextSubmitButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //textview
    [self.composeTextView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.pictureCollectionViewHeight.constant = ((TaoScreenWidth - 30 - (self.layout.totalRow - 1) * self.layout.minimumInteritemSpacing)/self.layout.totalRow) * (self.viewModel.pictures.count / 3 + 1);
    self.pictureCollectionViewHeight.constant = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //configerLayout
    self.layout.totalRow = 3;
    self.layout.totalColum = 3;
    self.layout.itemSize = CGSizeMake(((TaoScreenWidth - 30 - (self.layout.totalRow - 1) * self.layout.minimumInteritemSpacing)/self.layout.totalRow) , ((TaoScreenWidth - 30 - (self.layout.totalRow - 1) * self.layout.minimumInteritemSpacing)/self.layout.totalRow));

    
    [TaoNotificationCenter addObserver:self selector:@selector(insertEmtion:) name:TaoEmotionDidSelectNotification object:nil];
    [TaoNotificationCenter addObserver:self selector:@selector(deleteEmotion) name:TaoEmotionDidDeleteNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.pictureCollectionView.fd_collapsed = !self.viewModel.pictures.count;
    return self.viewModel.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"compose" forIndexPath:indexPath];//加手势
    cell.backgroundColor = [UIColor redColor];
    return cell;
}


#pragma collectionAndSsrollViewDelgate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark click

- (void)navLeftBtnClick:(id)sender {
    [self.composeTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ContainerTap:(id)sender {
    [self.composeTextView becomeFirstResponder];
}

#pragma mark getter

- (TaoComposeKeyBoardInputView *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[TaoComposeKeyBoardInputView alloc] init];
    }
    return _emotionKeyboard;
}

#pragma mark delegate
- (void)TaoComposeKeyBoardToolBarBtnClickWithTaoComposeKeyBoardToolBar:(TaoComposeKeyBoardToolBar *)toolBar type:(TaoComposeToolbarButtonType)type {
    switch (type) {
        case TaoComposeToolbarButtonTypeEmotion:{
            [self switchInputViewWithToolBar:toolBar];
            }
            break;
        case TaoComposeToolbarButtonTypePicture: {
            [self openAlbum];
        }
            
        default:
            break;
    }
}

- (void)switchInputViewWithToolBar:(TaoComposeKeyBoardToolBar *)toolBar {
    if (self.composeTextView.inputView == nil) { // 切换为自定义的表情键盘
        self.composeTextView.inputView = self.emotionKeyboard;
        
        toolBar.showKeyboardButton = YES;
    } else { // 切换为系统自带的键盘
        self.composeTextView.inputView = nil;
        
        toolBar.showKeyboardButton = NO;
    }
    // 退出键盘
    [self.composeTextView endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.composeTextView becomeFirstResponder];
    });
}

- (void)openAlbum {
    
}

#pragma mark notificenter
- (void)insertEmtion:(NSNotification *)dic {
    [self.composeTextView insertEmtion:dic];
}

- (void)deleteEmotion {
    [self.composeTextView deleteBackward];
}


@end
