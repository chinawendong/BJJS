//
//  BJZLContentViewController.m
//  BJJS
//
//  Created by 温仲斌 on 16/3/28.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "BJZLContentViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MacroManger.h"
#import "BJJDTitleTableViewController.h"
#import <AFNetworking.h>
#import <UIProgressView+AFNetworking.h>
#import "ProjiectCache.h"
#import "WebViewController.h"

@interface BJZLContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation BJZLContentViewController

- (void)loadNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle:) name:@"selectTitle" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.webView];
    [self.view addSubview:self.tableView];
    [self setLeftButton];
    [self loadNotification];
}

- (void)setLeftButton {
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *loginImg = [UIImage imageNamed:@"nav_menu"];
    loginImg = [loginImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [button1 setImage:loginImg forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button1.bounds = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem *barbutton2 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.mm_drawerController.navigationItem.rightBarButtonItem = barbutton2;
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)changeTitle:(NSNotification *)notification {
    
    _titleArray = notification.object[0];
    ProjiectCache *ceche = [ProjiectCache new];
    if (ceche.titleDictionary[notification.object[1]]) {
        self.mm_drawerController.title = ceche.titleDictionary[notification.object[1]];

    }else {
        self.mm_drawerController.title = notification.object[1];

    }

    [_tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_titleArray[indexPath.row] componentsSeparatedByString:@"\\"].lastObject;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *web = [[WebViewController alloc]init];
    web.urlString = _titleArray[indexPath.row];

    [self.navigationController pushViewController:web animated:YES];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
        _webView.backgroundColor = [UIColor redColor];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
