//
//  AllTableViewController.m
//
//
//  Created by 云族佳 on 16/5/27.
//
//

#import "AllTableViewController.h"

#import <Masonry.h>

#import "XWJSViewControllerCell.h"

#import "XWJSSJHederView.h"

#import "TheDatabaseManager.h"

#import "ProductClass.h"

#import "MacroManger.h"

#import "XWActionSheet.h"

#import "AddNewViewController.h"
#import "SearchViewController.h"


@interface AllTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *hederView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation AllTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJSViewControllerCell" bundle:nil] forCellReuseIdentifier:@"XWJSViewControllerCell"];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"全部资料";
    self.dataArray = [NSMutableArray array];
    [self notification];
    [self.view addSubview:self.hederView];
    [self.view bringSubviewToFront:self.hederView];
    [self.hederView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(44);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification) name:@"status" object:nil];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)search {
     SearchViewController *searchViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)notification {
    __weak typeof(self) weakBlock = self;

    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        weakBlock.dataArray = arr.mutableCopy;
        [weakBlock.tableView reloadData];
    }];
}

- (UIView *)hederView {
    if (!_hederView) {
        _hederView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 88)];
        XWJSSJHederView *h1 = [[XWJSSJHederView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44) withTitleArray:@[@"主板编号", @"主板密码", @"到期日期", @"出厂日期"]];
        XWJSSJHederView *h2 = [[XWJSSJHederView alloc]initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), 44) withTitleArray:@[@"代理商", @"客户姓名", @"解密人员", @"手机号码"]];
        [_hederView addSubview:h1];
        [_hederView addSubview:h2];
        
    }
    return _hederView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XWActionSheet *a = [[XWActionSheet alloc]initWithTitleArray:@[@"删除", @"修改", @"取消"]];
    [a setIdxBlock:^(NSInteger idx) {
        switch (idx) {
            case 0://删除
            {
                ProductClass *p = _dataArray[indexPath.section];
                [TheDatabaseManager delectWithProperty:@"productSerialNumber" andProperty:p.productSerialNumber withTableName:JIESUOTABELNAME];
                [self.dataArray removeObjectAtIndex:indexPath.item];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
            case 1://修改
            {
                AddNewViewController *add = [[AddNewViewController alloc]init];
                add.sevaTitle = @"修改";
                add.obj = _dataArray[indexPath.section];
                [self.navigationController pushViewController:add animated:YES];
            
            }
                break;
            default:
                break;
        }
    }];
    [a show];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.top.equalTo(self.view).offset(88);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    return _tableView;
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
