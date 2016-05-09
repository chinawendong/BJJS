//
//  MacroManger.h
//  BJJDProject
//
//  Created by 温仲斌 on 15/12/11.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define W CGRectGetWidth([UIScreen mainScreen].bounds)
#define H CGRectGetHeight([UIScreen mainScreen].bounds)

//数据库地址
#define kSQLPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"SQL"]

#define SQLITENAME @"BBJDSqlite.sqlite"

//解锁数据表名
#define JIESUOTABELNAME @"JieSuoBiaoMing"

@interface UIView (PushViewController)
//通过viewController类名快速创建 及跳转
- (void)veiwPushWithViewControllerName:(NSString *)viewControllerName isStoryboard:(BOOL)isStiryboard ;
//不处于viewController时 跳转方法
- (void)pushViewController:(UIViewController *)viewController;

- (UIViewController *)getCurrentViewController;

@end

@interface MacroManger : NSObject
//导入数据库
+ (void)moveSqliteFromDocument;
//获取 把对象的所有属性转换成字典
+ (NSDictionary *)getObjectPropertyAndValueWithObjc:(id)objc;
//获取对象所有属性名
+ (NSString *)getObjectAddTabelObjectString:(Class)cl;
//获取对象所有value
+ (NSString *)getObjectAllValueWithObjc:(id)objc;

+ (NSString *)getClassProtrName:(Class)class andString:(NSString *)str;
@end
