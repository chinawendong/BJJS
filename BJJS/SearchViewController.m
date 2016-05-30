#import "SearchViewController.h"

#import <Masonry.h>

#import "TheDatabaseManager.h"

#import "ProductClass.h"

#import "MacroManger.h"

#import "AddNewViewController.h"

#import "XWJSViewControllerCell.h"

#import "XWActionSheet.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"XWJSViewControllerCell" bundle:nil] forCellReuseIdentifier:@"XWJSViewControllerCell"];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [NSMutableArray array];
    self.tableView.tableHeaderView = self.searchBar;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification) name:@"status" object:nil];
    self.title = @"搜索";
}

- (void)notification {
    __weak typeof(self) weakBlock = self;
    
    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        weakBlock.dataArray = arr.mutableCopy;
        [weakBlock.tableView reloadData];
    }];
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
                [self.dataArray removeObjectAtIndex:indexPath.section];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIButton *)getSearchBarCancelButton{
    
    UIButton* btn=nil;
    
    for(UIView* v in self.searchBar.subviews.firstObject.subviews) {
        
        if ([v isKindOfClass:UIButton.class]) {
            
            btn=(UIButton*)v;
            
            break;
            
        }
    }
    
    return btn;
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    UIButton *button = [self getSearchBarCancelButton];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    id<SearchViewControllerDelegate> delegate = self.delegate;
    if (delegate)
    {
        [delegate searchControllerWillBeginSearch:self];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME conditions1:self.searchBar.text andConditions2:self.searchBar.text andConditions3:self.searchBar.text andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:arr];
        [self.tableView reloadData];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];

    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME conditions1:self.searchBar.text andConditions2:self.searchBar.text andConditions3:self.searchBar.text andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:arr];
        [self.tableView reloadData];
    }];

}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        _searchBar.placeholder = @"输入编号/代理商/客户名筛选";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.view).offset(0);
        }];
    }
    return _tableView;
}

@end
