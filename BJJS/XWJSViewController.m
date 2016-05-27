//
//  XWJSViewController.m
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/14.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "XWJSViewController.h"
#import "XWJSSJHederView.h"
#import "XWJSViewControllerCell.h"
#import "AddNewViewController.h"
#import "TheDatabaseManager.h"
#import "MacroManger.h"
#import "ProductClass.h"

@interface XWJSViewController ()<UITableViewDelegate>

@property (nonatomic, strong) XWJSSJHederView *hederView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XWJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJSViewControllerCell" bundle:nil] forCellReuseIdentifier:@"XWJSViewControllerCell"];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItm)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.title = @"用户列表";
    
    self.dataArray = [NSMutableArray array];
    __weak typeof(self) weakBlock = self;
    
    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        weakBlock.dataArray = arr.mutableCopy;
        [weakBlock.tableView reloadData];
    }];
    
}

- (XWJSSJHederView *)hederView {
    if (!_hederView) {
        _hederView = [[XWJSSJHederView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    }
    return _hederView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (void)addItm {
    __weak typeof(self) weakBlock = self;
    NSInteger count = _dataArray.count;
    [_dataArray removeAllObjects];
    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        weakBlock.dataArray = arr.mutableCopy;
        if (_dataArray.count != count) {
            [weakBlock.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XWJSViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XWJSViewControllerCell" forIndexPath:indexPath];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(XWJSViewControllerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setData:_dataArray[indexPath.section]];

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.hederView;
}


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
