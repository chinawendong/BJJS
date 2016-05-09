//
//  MacroManger.m
//  BJJDProject
//
//  Created by 温仲斌 on 15/12/11.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import "MacroManger.h"

#import <objc/runtime.h>

#import "TheDatabaseManager.h"

#import "ProductClass.h"

@implementation MacroManger

+ (void)moveSqliteFromDocument {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:kSQLPath]) {
        [manager createFileAtPath:kSQLPath contents:nil attributes:nil];
        if ([manager copyItemAtPath:[[NSBundle mainBundle] pathForResource:SQLITENAME ofType:nil] toPath:kSQLPath error:nil]) {
            UIAlertView *al   = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数据库导入失败" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [al show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [al dismissWithClickedButtonIndex:0 animated:YES];
            });
        }else {
            NSLog(@"数据库导入成功");
            [TheDatabaseManager addTabelWithObjectClass:[ProductClass class] andTableName:JIESUOTABELNAME];
        }
        
    }
}

+ (NSString *)getObjectAddTabelObjectString:(Class)cl {
    NSMutableString *str = [NSMutableString string];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cl, &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if (i == outCount - 1) {
            [str appendString:[NSString stringWithFormat:@"%@ text", propertyName]];
        }else {
            [str appendString:[NSString stringWithFormat:@"%@ text,", propertyName]];
        }
    }
//    NSLog(@"%@", str);
    free(properties);
    return str;
}

+ (NSString *)getObjectAllValueWithObjc:(id)objc {
    NSMutableString *str = [NSMutableString string];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([objc class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [objc valueForKey:(NSString *)propertyName];
        if (i == outCount - 1) {
            [str appendString:[NSString stringWithFormat:@"'%@'", propertyValue]];
        }else{
            [str appendString:[NSString stringWithFormat:@"'%@',", propertyValue]];
        }
    }
    free(properties);
    return str;
}

+ (NSDictionary *)getObjectPropertyAndValueWithObjc:(id)objc {
    NSMutableString *str = [NSMutableString string];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([objc class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [objc valueForKey:(NSString *)propertyName];
        [dic setValue:propertyValue forKey:propertyName];
        
        [str appendString:[NSString stringWithFormat:@"'%@',", propertyValue]];
    }
    free(properties);
    return dic;
}

@end

@implementation UIView (PushViewController)

- (void)veiwPushWithViewControllerName:(NSString *)viewControllerName isStoryboard:(BOOL)isStiryboard {
    //获取当前viewController
    UIViewController *currentViewController = [self getCurrentViewController];
    id obj;
    if (isStiryboard) {
        obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:viewControllerName];
    }else{
        obj = [[NSClassFromString(viewControllerName) alloc]init];
    }
    [currentViewController.navigationController pushViewController:obj animated:YES];
}

- (UIViewController *)getCurrentViewController {
    UINavigationController *currenNavigationController = (UINavigationController *)self.window.rootViewController;
    UIViewController *currenViewController = currenNavigationController.visibleViewController;
    [currenViewController.navigationController setHidesBottomBarWhenPushed:YES];
    return currenViewController;
}

- (void)pushViewController:(UIViewController *)viewController {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
             [[self getCurrentViewController].navigationController pushViewController:viewController animated:YES];
        });
    });
}

+ (NSString *)getClassProtrName:(Class)class andString:(NSString *)str {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    NSMutableString *sqlStr = [NSMutableString string];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        //获取属性名字
        const char * name = property_getName(property);
        [sqlStr appendString:[NSString stringWithFormat:@"%s %@,", name, str]];
        //        //获取属性类型
        //        const char * attributes = property_getAttributes(property);
    }
    free(properties);
    return [sqlStr substringToIndex:sqlStr.length - 2];
}


@end
