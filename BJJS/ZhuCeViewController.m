//
//  ZhuCeViewController.m
//  BJJS
//
//  Created by 云族佳 on 16/4/12.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "ZhuCeViewController.h"

#import "XWNetworking.h"
@interface ZhuCeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *name;

@end

@implementation ZhuCeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)button:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)zhuce:(id)sender {
    if (_userName.text.length && _positionTextField.text.length && _companyNameTextField.text.length && _password.text.length && _name.text.length) {
        [XWNetworking postNetworkingPostString2:@"textServlet" parameters:@{@"kouhao" : @"zhuce", @"name" : _phone, @"pwd" : _password.text, @"zhiwei" : _userName.text, @"gongsimingcheng" : _companyNameTextField.text, @"suozaidi" : _positionTextField.text, @"xingming" : _name.text
                                                                           } success:^(id data) {
                                                                               if (![data isEqualToString:@"此号码已被注册,请更换其他手机号!"]) {
                                                                                   UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"滨捷提示" message:data delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                                                                   [al show];
                                                                               }else {
                                                                                   [self dismissViewControllerAnimated:YES completion:nil];
                                                                                   
                                                                               }
                                                                           } failure:^(NSError *error) {
                                                                               NSLog(@"%@", error);
                                                                                                                                                                 [self.navigationController popToRootViewControllerAnimated:YES];

                                                                           }];
    }else {
        
    }
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
