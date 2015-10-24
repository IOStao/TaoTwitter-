//
//  TaoHomeTitleBtn.m
//  韬微博4.0
//
//  Created by wzt on 15/10/21.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "TaoHomeTitleBtn.h"
#define NavBarHeight 64
#define PopWidth  217
#define TitleImageMarign 10
#define PopHeight 350
#define PopArrowHeight 10
#define TableViewMargin 10
#define TableViewTop 6
#define cellHeight 36
#define btnHeight  28
#define identifier  @"cell"


@interface TaoHomeTitleMenu()
#warning image的变化
@end

@implementation TaoHomeTitleBtn

+ (instancetype)TitleBtnWithTitle:(NSString *)title {
    return [[TaoHomeTitleBtn alloc] initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //调整间距
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, [self.titleLabel.text sizeWithFont:self.titleLabel.font].width + TitleImageMarign, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,- self.currentImage.size.width, 0, self.currentImage.size.width + TitleImageMarign)];
    self.size = CGSizeMake(self.currentImage.size.width + [self.titleLabel.text sizeWithFont:self.titleLabel.font].width + TitleImageMarign, [self.titleLabel.text sizeWithFont:self.titleLabel.font].height);
    
    [self addTarget:self action:@selector(btnClick:)forControlEvents:UIControlEventTouchUpInside];
    
    [TaoNotificationCenter addObserver:self selector:@selector(removeMenu) name:TaoHomeTitleWindowRemoveNotification object:nil];
    }
    return self;
}

- (void)btnClick:(TaoHomeTitleBtn *)btn {
    TaoHomeTitleMenu *menu = [TaoHomeTitleMenu sharedInstance];
    menu.MaxY = CGRectGetMaxY(btn.frame);
    if (!btn.selected) {
        btn.selected = YES;
        [menu show];
    }else {
        btn.selected = NO;
        [menu remove];
    }
}

- (void)removeMenu {
    [self btnClick:self];
}

- (void)dealloc {
    [TaoNotificationCenter removeObserver:self];
}

@end

@interface TaoHomeTitleMenu ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *menuTableView;

@end

@implementation TaoHomeTitleMenu

+ (TaoHomeTitleMenu *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.9;
        UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake((TaoScreenWidth - PopWidth)/2, NavBarHeight - PopArrowHeight, PopWidth, PopHeight)];
        menuView.backgroundColor = [UIColor clearColor];
        [self addSubview:menuView];
        
        UIImageView *imageBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_background"]];
        imageBackground.frame = menuView.bounds;
        [menuView addSubview:imageBackground];
        
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake (TableViewMargin,TableViewTop + PopArrowHeight, PopWidth - 2 *TableViewMargin, PopHeight - btnHeight  - 2 *TableViewMargin - PopArrowHeight)];
        [menuView addSubview:_menuTableView];
        _menuTableView.backgroundColor = [UIColor tao_titleMenuColor];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(TableViewMargin, CGRectGetMaxY(_menuTableView.frame), PopWidth - 2 *TableViewMargin, btnHeight);
        [btn setBackgroundImage:[UIImage imageNamed:@"popover_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"popover_button_highlighted"] forState:UIControlStateHighlighted];
        [btn setTitle:@"编辑你的分组" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self  action:@selector(BtnEdit:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
       
    }
    return self;
}

- (void)show {
    [self makeKeyWindow];
    self.hidden = NO;
}

- (void)remove {
    [self resignKeyWindow];
    self.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self remove];
    [TaoNotificationCenter postNotificationName:TaoHomeTitleWindowRemoveNotification object:nil];
    
}

#pragma tableViewDatasource delagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning use NSArray
    return 19;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = identifier ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor tao_titleMenuColor];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"popover_background_highlighted"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma Btn
- (void) BtnEdit:(UIButton *)btn {
    [self remove];
    [TaoNotificationCenter postNotificationName:TaoHomeTitleWindowRemoveNotification object:nil];
    [TaoNotificationCenter postNotificationName:TaoHomeTitleMenuEditBtnNotification object:nil];
    
}
@end
