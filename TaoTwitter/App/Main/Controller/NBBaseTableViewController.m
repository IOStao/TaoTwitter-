
//  NBBaseTableViewController.m
//  TaoTwitter
//
//  Created by wzt on 15/10/31.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "NBBaseTableViewController.h"
#import "CBStoreHouseRefreshControl.h"



@interface NBBaseTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, weak) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@end

@implementation NBBaseTableViewController

- (void)dealloc {
    
    [TaoNotificationCenter removeObserver:self];
    TaoLog(@"%@ dealloc",[self class]);
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

- (instancetype)init
{
    self = [super init];
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor tao_homeEditCellColor];
    
    // Do any additional setup after loading the view.
#warning 研究
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navBarConfig configBarItems];
 
}

#pragma mark - Table view data source

- (void)setAddPullDown:(BOOL)addPullDown {
    _addPullDown = addPullDown;
    if (_addPullDown) {
        self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"twitter" color:[UIColor redColor] lineWidth:3 dropHeight:80 scale:0.7 horizontalRandomness:150 reverseLoadingAnimation:NO internalAnimationFactor:0.7];
    }

}

- (void)setAddPullUp:(BOOL)addPullUp {
    _addPullUp = addPullUp;
    if (_addPullUp) {
        __weak typeof(self)weakSelf = self;
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadMoreData];
        }];
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender {
    [self performSelector:@selector(loadNewData) withObject:nil afterDelay:0.4];
}

- (void)finfishPullDuwn {
    [self.storeHouseRefreshControl finishingLoading];
}

- (void)loadCacheData {
    
}

- (void)loadNewData {
    
}

- (void)loadMoreData {
    
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
