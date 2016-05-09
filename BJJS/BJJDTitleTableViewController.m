//
//  BJJDTitleTableViewController.m
//  BJJS
//
//  Created by 温仲斌 on 16/3/28.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "BJJDTitleTableViewController.h"

#import "XWNetworking.h"

#import "UIViewController+MMDrawerController.h"

#import "BJZLContentViewController.h"

#import "ProjiectCache.h"

static NSInteger idx = -1;

@interface BJJDTitleTableViewController ()

@end

@implementation BJJDTitleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_titleArray.count) {
        return _titleArray.count;
    }
    return _titleArray.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([ProjiectCache new].titleDictionary[_titleArray[indexPath.row]]) {
        cell.textLabel.text = [ProjiectCache new].titleDictionary [_titleArray[indexPath.row]];

    }else {
        cell.textLabel.text = _titleArray[indexPath.row];
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (idx != indexPath.row) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *titleString = _titleArray[indexPath.row];
        [_urlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj rangeOfString:@".et"].location  != NSNotFound ? [obj stringByReplacingOccurrencesOfString:@".et" withString:@".xls"]:nil;
            [obj rangeOfString:titleString].location != NSNotFound ? [array addObject:obj]:nil;
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTitle" object:@[array, _titleArray[indexPath.row]]];
    }
    idx = indexPath.row;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
}

- (void)loadData {
    
    ProjiectCache *cache = [ProjiectCache new];
    BOOL flag = [_parameters[@"kouhao"] isEqualToString:@"gongchengcanshu"];
    NSMutableArray *array = [NSMutableArray array];

    NSArray *arrT = [cache getCacheArrayWithPath:!flag];
    if (arrT) {
        _titleArray = arrT.firstObject;
        _urlArray = arrT.lastObject;
        NSString *titleString = _titleArray[0];
        [_urlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj rangeOfString:titleString].location != NSNotFound ? [array addObject:obj]:nil;
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTitle" object:@[array, _titleArray[0]]];
        [self.tableView reloadData];
    }
    __weak typeof(self) weakSelf = self;
    [XWNetworking postNetworkingPostString:self.urlString parameters:self.parameters success:^(id data) {
        data = [data stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *arr = [data componentsSeparatedByString:@"#"];
        NSArray *arrA = [arr.firstObject componentsSeparatedByString:@"@"];
        NSArray *arrB = [arr.lastObject componentsSeparatedByString:@"@"];
        weakSelf.urlArray = arrB;
        if ([arrT.firstObject count] != arrA.count) {
            weakSelf.titleArray = arrA;
            [weakSelf.tableView reloadData];
            [cache removeAllProjiectCache:!flag];
            NSArray *ar = @[arrA, arrB];
            [cache installHaoYouArray:ar withType:!flag];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectTitle" object:@[_urlArray, _titleArray[0]]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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
