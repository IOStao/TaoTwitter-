//
//  NBBaseViewController.m
//  韬微博4.0
//
//  Created by wzt on 15/10/20.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "NBBaseViewController.h"
#import "TaoNavigationBarConfig.h"

@interface NBBaseViewController ()

@end

@implementation NBBaseViewController

- (void)dealloc {
    [TaoNotificationCenter removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureSelf];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configureSelf];
    }
    return self;
}

- (void)configureSelf {
    // Custom initialization
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#warning 研究
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navBarConfig configBarItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
