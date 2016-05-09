//
//  ViewController.m
//  BJJS
//
//  Created by 温仲斌 on 16/2/17.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "ViewController.h"

#import "JieSuoView.h"

#import "UIViewController+MMDrawerController.h"

#import "DTKDropdownMenuView.h"

#import "MMDrawerController.h"

#import "BJZLContentViewController.h"

#import "BJJDTitleTableViewController.h"

#import "MMExampleDrawerVisualStateManager.h"

#import "LoginViewController.h"

#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]

@interface ViewController (){
    UIScrollView *showView ;
    CGRect rect;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"滨捷机电解锁系统";
    JieSuoView *jiesuoView = [[JieSuoView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:jiesuoView];
    [self addleftItem];
    
//    UINavigationController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    NSMutableArray *a = self.navigationController.viewControllers.mutableCopy;
//    [a addObject:vc];
////    [self.navigationController setViewControllers:a];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addleftItem
{
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"滨捷资料" callBack:^(NSUInteger index, id info) {
        [self setPushURL:@"listviewServlet" endParameters:@{@"kouhao" : @"binjieziliao"}];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"系统资料" callBack:^(NSUInteger index, id info) {
        [self setPushURL:@"xiazaiServlet" endParameters:@{@"kouhao" : @"gongchengcanshu"}];
    }];

    
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeLeftItem frame:CGRectMake(0, 0, 44.f, 44.f) dropdownItems:@[item0,item1] icon:@"nav_menu"];
    menuView.dropWidth = 100.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = ColorWithRGB(102.f, 102.f, 102.f);
    menuView.textFont = [UIFont systemFontOfSize:13.f];
    menuView.cellSeparatorColor = ColorWithRGB(229.f, 229.f, 229.f);
    menuView.textFont = [UIFont systemFontOfSize:14.f];
    menuView.animationDuration = 0.2f;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

- (void)setPushURL:(NSString *)url endParameters:(NSDictionary *)parameters {
    BJZLContentViewController *cent = [[BJZLContentViewController alloc]init];
    BJJDTitleTableViewController *titleC = [[BJJDTitleTableViewController alloc]initWithStyle:UITableViewStylePlain];
    titleC.urlString = url;
    titleC.parameters = parameters;
    MMDrawerController *viewC = [[MMDrawerController alloc]initWithCenterViewController:cent rightDrawerViewController:titleC];
    viewC.showsShadow                                              = YES;
    viewC.centerHiddenInteractionMode                              = MMDrawerOpenCenterInteractionModeNavigationBarOnly;
    
    viewC.statusBarViewBackgroundColor                             = [UIColor redColor];
    
    //设置侧边栏的宽度
    viewC.maximumRightDrawerWidth = 100;
    
    //侧边栏手势
    [viewC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [viewC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType  = MMDrawerAnimationTypeSlideAndScale;
    
    
    [viewC
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block                                                                      = [[MMExampleDrawerVisualStateManager sharedManager]
                                                                                       drawerVisualStateBlockForDrawerSide:drawerSide];
         
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [self.navigationController pushViewController:viewC animated:YES];
}

- (void)setLeftButton {
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.showsTouchWhenHighlighted = YES;
    UIImage *loginImg = [UIImage imageNamed:@"nav_menu"];
    loginImg = [loginImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [button1 setImage:loginImg forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    button1.bounds = CGRectMake(0, 0, 32, 32);
    UIBarButtonItem *barbutton2 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = barbutton2;
}

-(void)leftDrawerButtonPress:(id)sender{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
