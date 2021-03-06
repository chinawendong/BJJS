//
//  AppDelegate.m
//  BJJS
//
//  Created by 温仲斌 on 16/2/17.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "AppDelegate.h"

#import "MacroManger.h"

#import "XWNetworking.h"

#import "LeftViewController.h"

#import "ViewController.h"

#import "LoginViewController.h"

#import <SMS_SDK/SMSSDK.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

//微信SDK头文件
#import "WXApi.h"

#import "JieMa.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [MacroManger moveSqliteFromDocument];
    [SMSSDK registerApp:@"118f24a7d18a4" withSecret:@"daf1e4cd0a73ffdaa7793ba97bccb837"];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyWindow];
    
    ViewController *v = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:v];
    self.window.rootViewController = nav;

    
//    NSTimeInterval t = ceil([NSDate date].timeIntervalSince1970);
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"fist"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fist"];
//        UINavigationController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        LoginViewController *lo = (LoginViewController *)vc.visibleViewController;
//        [lo setPushRootViewController:^{
//            ViewController *v = [[ViewController alloc]init];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:v];
//            self.window.rootViewController = nav;
//            [[NSUserDefaults standardUserDefaults]setValue:@(t) forKey:@"timer"];
//        }];
//        self.window.rootViewController = vc;
//    }else {
//        if ((ceilf((t - [[[NSUserDefaults standardUserDefaults] valueForKey:@"timer"] doubleValue]) / (60 * 60 * 24))) < 30) {
//            ViewController *v = [[ViewController alloc]init];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:v];
//            self.window.rootViewController = nav;
//        }else {
//            UINavigationController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            LoginViewController *lo = (LoginViewController *)vc.visibleViewController;
//            [lo setPushRootViewController:^{
//                ViewController *v = [[ViewController alloc]init];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:v];
//                self.window.rootViewController = nav;
//                [[NSUserDefaults standardUserDefaults]setValue:@(t) forKey:@"timer"];
//            }];
//            self.window.rootViewController = vc;
//        }
//    }
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    

    [ShareSDK registerApp:@"11ae3ec9a35cc"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformSubTypeQQFriend:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx70363a16fc0a53bc"
                                       appSecret:@"d1855705c24eeb27557936c49c56dd74"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105333558"
                                      appKey:@"r9t99S3QLxFQ9cJ5"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
