//
//  LoginViewController.m
//  BJJS
//
//  Created by 云族佳 on 16/4/12.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "LoginViewController.h"

#import "RegViewController.h"

#import "ZhuCeViewController.h"

#import "XWNetworking.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController{
    UIImageView *image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请登入滨捷系统";
    
    
    [XWNetworking postNetworkingPostString2:@"textServlet" parameters:@{@"kouhao" : @"zhuce", @"name" : @"13030840306", @"pwd" : @"123456789",  @"xingming" : @"f2safsa", @"zhiwei" : @"fasfs1" , @"gongsimingcheng" : @"fasfs1d", @"suozaidi" : @"fs1afs"} success:^(id data) {
                                                                            if (![data isEqualToString:@"此号码已被注册,请更换其他手机号!"]) {
                                                                                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"滨捷提示" message:data delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                                                                [al show];
                                                                            }else {
                                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                                                
                                                                            }
                                                                        } failure:^(NSError *error) {
                                                                            NSLog(@"%@", error);
//                                                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                                                            
                                                                        }];

}


- (IBAction)login:(id)sender {
    [XWNetworking postNetworkingPostString2:@"testServlet" parameters:@{@"kouhao" : @"denglu", @"name" : _accountTextField.text , @"pwd" : _passwordTextField.text} success:^(id data) {
        if ([data isEqualToString:@"帐号不存在!"]) {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"滨捷提示" message:data delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [al show];
            return;
        }
        if ([data length] == _accountTextField.text.length + _passwordTextField.text.length) {
            if ([[data substringWithRange:NSMakeRange(0, 11)] isEqualToString:_accountTextField.text] && [[data substringFromIndex:11] isEqualToString:_passwordTextField.text]) {
                if (_pushRootViewController) {
                    _pushRootViewController();
                }
            }else {
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"滨捷提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [al show];
            }
        }
            }failure:^(NSError *error) {
                                                                           NSLog(@"%@", error);
                                                                       }];
    
}
- (IBAction)tap:(id)sender {
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
- (IBAction)zhuce:(id)sender {
    RegViewController* reg = [[RegViewController alloc] init];
    [self presentViewController:reg animated:YES completion:^{
        
    }];
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
