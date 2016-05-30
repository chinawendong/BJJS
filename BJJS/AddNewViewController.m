//
//  AddNewViewController.m
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/18.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "AddNewViewController.h"

#import "XWTextFiledScrollView.h"

#import "AddNewViewControllerView.h"

@interface AddNewViewController ()

@property (nonatomic, strong) XWTextFiledScrollView *scrollView;

@end

@implementation AddNewViewController

- (void)loadView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddNewViewControllerView" owner:nil options:nil];
    AddNewViewControllerView *addView =[nibView objectAtIndex:0];
    if (_sevaTitle.length) {
        addView.sevaTitle = self.sevaTitle;
    }else {
        addView.sevaTitle = @"提交";
    }
    if (_obj) {
        addView.obj = _obj;
    }
    if (self.sevaTitle.length) {
        self.title = @"修改用户信息";
    }else {
        self.title = @"添加新用户";
    }
    self.view = addView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (XWTextFiledScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[XWTextFiledScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _scrollView;
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
