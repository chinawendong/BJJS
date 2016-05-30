//
//  TheDatabaseManager.h
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/15.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TheDatabaseManager : NSObject
//新建表
+ (void)addTabelWithObjectClass:(Class)cl andTableName:(NSString *)tableNmae;
//添加数据
+ (void)addObjectDataWithTableName:(NSString *)tableName installObject:(id)objc oldObject:(id)object withAlerFlag:(BOOL)flag;
//关键字查询
+ (NSArray *)searchFromTableName:(NSString *)tableName withKey:(NSString *)key andObjece:(NSString *)nekey ;
+ (void)quaueupdataList:(NSString *)listName andProperString:(NSString *)proper withSteing:(NSString *)str andNewString:(NSString *)newstr andClass:(Class)cl withBlock:(void (^)(NSArray *arr))block;
//更新时间
+ (void)update:(NSString *)tableName installObject:(id)objc;
//删除某行
+ (void)delectWithProperty:(NSString *)property andProperty:(NSString *)p withTableName:(NSString *)tableName;
//按照关键查询
+ (void)quaueupdataList:(NSString *)listName conditions1:(NSString *)conditions1 andConditions2:(NSString *)conditions2 andConditions3:(NSString *)conditions3 andClass:(Class)cl withBlock:(void (^)(NSArray *arr))block;
@end
