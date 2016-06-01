//
//  TheDatabaseManager.m
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/15.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "TheDatabaseManager.h"

#import <FMDB.h>

#import "MacroManger.h"

#import "ProductClass.h"

#import <objc/runtime.h>

#import "XWActionSheet.h"

@implementation TheDatabaseManager

+ (void)addTabelWithObjectClass:(Class)cl andTableName:(NSString *)tableNmae {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kSQLPath];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)", tableNmae,[MacroManger getObjectAddTabelObjectString:cl]];
        [db executeUpdate:sqlCreateTable] ? NSLog(@"成功") : nil;
    }];
}

+ (void)update:(NSString *)tableName installObject:(id)objc {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kSQLPath];
    [queue inDatabase:^(FMDatabase *db) {
        if ([objc isKindOfClass:[ProductClass class]]) {
            ProductClass *pc = objc;
            [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'", tableName,@"dateOld", pc.dateOld,@"productSerialNumber", pc.productSerialNumber]]? NSLog(@"更新成功") : NSLog(@"更新失败");
        }
    }];
}

+ (void)addObjectDataWithTableName:(NSString *)tableName installObject:(id)objc oldObject:(id)object withAlerFlag:(BOOL)flag {
    if ([objc isKindOfClass:[ProductClass class]]) {
        ProductClass *pc = object;
        FMDatabase *db = [FMDatabase databaseWithPath:kSQLPath];
        NSArray *arr = [TheDatabaseManager searchFromTableName:JIESUOTABELNAME withKey:@"productSerialNumber" andObjece:pc.productSerialNumber];
        NSArray *arr1 = [TheDatabaseManager searchFromTableName:JIESUOTABELNAME withKey:@"productSerialNumber" andObjece:[objc productSerialNumber]];
        if ([db open]) {
            if (arr.count) {
                    if (flag) {
                        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE productSerialNumber = '%@'", tableName,pc.productSerialNumber]]? NSLog(@"删除成功") : nil;
                        if (arr1.count) {
                            [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE productSerialNumber = '%@'", tableName,[objc productSerialNumber]]]? NSLog(@"删除成功") : nil;
                        }
                        
                        NSString *insertSql1= [NSString stringWithFormat:
                                               @"INSERT INTO '%@' (%@) VALUES (%@)",tableName, [[MacroManger getObjectAddTabelObjectString:[objc class]]stringByReplacingOccurrencesOfString:@"text" withString:@""], [MacroManger getObjectAllValueWithObjc:objc]];
                        [db executeUpdate:insertSql1] ? ({flag ? [self popAlertView:@"修改数据成功"]:nil;}) : ({flag ? [self popAlertView:@"修改数据失败"]:nil;});
                    }
            }else {
                if (arr1.count) {
                    [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE productSerialNumber = '%@'", tableName,[objc productSerialNumber]]]? NSLog(@"删除成功") : nil;
                }

                NSString *insertSql1= [NSString stringWithFormat:
                                       @"INSERT INTO '%@' (%@) VALUES (%@)",tableName, [[MacroManger getObjectAddTabelObjectString:[objc class]]stringByReplacingOccurrencesOfString:@"text" withString:@""], [MacroManger getObjectAllValueWithObjc:objc]];
                [db executeUpdate:insertSql1] ? ({flag ? [self popAlertView:@"添加数据成功"]:nil;}) : ({flag ? [self popAlertView:@"添加数据失败"]:nil;});
            }

            }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"status" object:nil];
        }
}

+ (void)delectWithProperty:(NSString *)property andProperty:(NSString *)p withTableName:(NSString *)tableName {
    FMDatabase *db = [FMDatabase databaseWithPath:kSQLPath];
    if ([db open]) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@", tableName, property, p]]? NSLog(@"删除成功") : nil;
    }
    
}

+ (NSArray *)searchFromTableName:(NSString *)tableName withKey:(NSString *)key andObjece:(NSString *)nekey {
    FMDatabase *db = [FMDatabase databaseWithPath:kSQLPath];
    if ([db open]) {
        //SELECT %@ FROM %@ WHERE name like '%@'",condition
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%%%@%%'",tableName,key,nekey];
        FMResultSet * rs = [db executeQuery:query];
        NSMutableArray *arr = [NSMutableArray array];
        while ([rs next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *array = [[self getClassProtrName:[ProductClass class] andString:@""] componentsSeparatedByString:@" ,"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                dic[obj] = [rs stringForColumn:obj];
//                NSLog(@"%@", dic[obj]);
            }];
            @autoreleasepool {
                id user = [[ProductClass alloc]init];
                [user setValuesForKeysWithDictionary:dic];
                [arr addObject:user];
            }
            
        }
        
        return arr;
    }
    return nil;
}

//查询所有数据
+ (void)quaueupdataList:(NSString *)listName andProperString:(NSString *)proper withSteing:(NSString *)str andNewString:(NSString *)newstr andClass:(Class)cl withBlock:(void (^)(NSArray *arr))block{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kSQLPath];
    __weak __typeof(self) selfBlock = self;
    
    [queue inDatabase:^(FMDatabase *db1) {
        
        FMResultSet *rs = [db1 executeQuery:[NSString stringWithFormat:@"select * from %@", listName]];
        NSMutableArray *arr = [NSMutableArray array];
        while ([rs next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *array = [[selfBlock getClassProtrName:cl andString:@""] componentsSeparatedByString:@" ,"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                dic[obj] = [rs stringForColumn:obj];
//                NSLog(@"%@", dic[obj]);
            }];
            @autoreleasepool {
                id user = [[cl alloc]init];
                [user setValuesForKeysWithDictionary:dic];
                [arr addObject:user];
            }
            
        }
        block(arr);
    }];
}

+ (void)quaueupdataList:(NSString *)listName conditions1:(NSString *)conditions1 andConditions2:(NSString *)conditions2 andConditions3:(NSString *)conditions3 andClass:(Class)cl withBlock:(void (^)(NSArray *arr))block {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:kSQLPath];
    __weak __typeof(self) selfBlock = self;
    [queue inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE productSerialNumber LIKE '%%%@%%' or productServiceName LIKE '%%%@%%' or productAgent LIKE '%%%@%%'",listName,conditions1,conditions2,conditions3];
        FMResultSet * rs = [db executeQuery:query];
        NSMutableArray *arr = [NSMutableArray array];
        while ([rs next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *array = [[selfBlock getClassProtrName:cl andString:@""] componentsSeparatedByString:@" ,"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                dic[obj] = [rs stringForColumn:obj];
            }];
            @autoreleasepool {
                id user = [[cl alloc]init];
                [user setValuesForKeysWithDictionary:dic];
                [arr addObject:user];
            }
        }
        
        //        NSString *query2 = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE productServiceName LIKE '%%%@%%'",listName,conditions2];
        //        FMResultSet * rs2 = [db executeQuery:query2];
        //        while ([rs2 next]) {
        //            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //            NSArray *array = [[selfBlock getClassProtrName:cl andString:@""] componentsSeparatedByString:@" ,"];
        //            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //                dic[obj] = [rs stringForColumn:obj];
        //            }];
        //            @autoreleasepool {
        //                id user = [[cl alloc]init];
        //                [user setValuesForKeysWithDictionary:dic];
        //                [arr addObject:user];
        //            }
        //
        //        }
        //
        //        NSString *query3 = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE productAgent LIKE '%%%@%%'",listName,conditions3];
        //        FMResultSet * rs3 = [db executeQuery:query3];
        //        while ([rs3 next]) {
        //            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //            NSArray *array = [[selfBlock getClassProtrName:cl andString:@""] componentsSeparatedByString:@" ,"];
        //            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //                dic[obj] = [rs stringForColumn:obj];
        //            }];
        //            @autoreleasepool {
        //                id user = [[cl alloc]init];
        //                [user setValuesForKeysWithDictionary:dic];
        //                [arr addObject:user];
        //            }
        //
        //        }
        block(arr);
    }];
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
    }
    free(properties);
    return [sqlStr substringToIndex:sqlStr.length - 2];
}

+ (void)popAlertView:(NSString *)str {
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"小提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的~", nil];
    al.delegate = self;
    [al show];
}

@end
