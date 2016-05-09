//
//  JieMa.m
//  BingJieJiDian
//
//  Created by Pop Web on 15/9/2.
//  Copyright (c) 2015年 滨捷机电. All rights reserved.
//

#import "JieMa.h"

#import "TheDatabaseManager.h"

#import "MacroManger.h"

#import <UIKit/UIKit.h>

#import "WXPayView.h"

#import "ProductClass.h"

#define INITMUTABLEARRAY [NSMutableArray array]

static const int mabiao0[] = {7,6,4,1,9,8,3,2,5,0};
static const int mabiao1[] = {2,9,3,4,7,5,6,8,0,1};
static const int mabiao2[] = {1,5,8,2,3,6,0,9,4,7};
static const int mabiao3[] = {6,7,9,3,1,4,2,0,8,5};
static const int mabiao4[] = {5,4,2,6,8,0,7,1,3,9};
static const int mabiao5[] = {8,3,1,5,0,2,9,4,7,6};
static const int mabiao6[] = {4,2,6,0,5,9,8,7,1,3};
static const int mabiao7[] = {9,1,0,7,6,3,4,5,2,8};
static const int mabiao8[] = {3,0,5,8,2,7,1,6,9,4};
static const int mabiao9[] = {0,8,7,9,4,1,5,3,6,2};

@interface JieMa ()<UIAlertViewDelegate>

@property (nonatomic,copy) void (^jieMaBlock)();

@end

@implementation JieMa

int GetInt(int x, int y) {
    int k;
    int z = 0;
    switch (x) {
        case 0:
            return z = mabiao0[y];
        case 1:
            return z = mabiao1[y];
        case 2:
            return z = mabiao2[y];
        case 3:
            return z = mabiao3[y];
        case 4:
            return z = mabiao4[y];
        case 5:
            return z = mabiao5[y];
        case 6:
            return z = mabiao6[y];
        case 7:
            return z = mabiao7[y];
        case 8:
            return z = mabiao8[y];
        case 9:
            return z = mabiao9[y];
            
        default:
            break;
    }
    return k = z;
}

NSArray * Getdate(NSArray * arr) {
    NSMutableArray *arrOut = [NSMutableArray array];
//    arrOut[1] = @(GetInt([arr[3] intValue], 5));
//    arrOut[3] = @(GetInt([arr[1] intValue], [arrOut[1] intValue]));
//    arrOut[0] = @(GetInt([arr[2] intValue], [arrOut[3] intValue]));
//    arrOut[2] = @(GetInt([arr[0] intValue], [arrOut[0] intValue]));
    
    arrOut[0] = @(GetInt([arr[3] intValue], 5));
    arrOut[1] = @(GetInt([arr[1] intValue], [arrOut[0] intValue]));
    arrOut[2] = @(GetInt([arr[2] intValue], [arrOut[1] intValue]));
    arrOut[3] = @(GetInt([arr[0] intValue], [arrOut[2] intValue]));
    
    return [NSArray arrayWithObjects:arrOut[2], arrOut[0],arrOut[3],arrOut[1],nil];
}

+ (NSString *)stringWithText:(NSString *)string {
    //返回的密码
    NSMutableString *mimaString = [NSMutableString string];
    NSMutableArray *arrString = [NSMutableArray array];
    for (int i = 0; i < string.length; i++) {
        [arrString addObject:[string substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSMutableArray *ia = INITMUTABLEARRAY;
    NSMutableArray *ib = INITMUTABLEARRAY;
    NSMutableArray *ic = INITMUTABLEARRAY;
    NSMutableArray *ie = INITMUTABLEARRAY;
    NSMutableArray *iel = INITMUTABLEARRAY;
    NSMutableArray *iell = INITMUTABLEARRAY;

    //添加日期
    [ia addObjectsFromArray:@[arrString[12],arrString[13],arrString[14]]];
    //添加主板编号密码
    [ib addObjectsFromArray:@[arrString[6],arrString[7],arrString[8],arrString[9],arrString[10],arrString[11]]];
    //添加随机码
    [ic addObjectsFromArray:@[arrString[0],arrString[1],arrString[2],arrString[3],arrString[4],arrString[5]]];
    for (int j = 0; j < ib.count; j++) {
        switch (j) {
            case 0:
                ie[0] = @(GetInt([ib[0] intValue], [ic[0] intValue]));
                break;
            case 1:
                ie[1] = @(GetInt([ib[1] intValue], [ic[1] intValue]));
                break;
            case 2:
                ie[2] = @(GetInt([ib[2] intValue], [ic[2] intValue]));
                break;
            case 3:
                ie[3] = @(GetInt([ib[3] intValue], [ic[3] intValue]));
                break;
            case 4:
                ie[4] = @(GetInt([ib[4] intValue], [ic[4] intValue]));
                break;
            case 5:
                ie[5] = @(GetInt([ib[5] intValue], [ic[5] intValue]));
                break;
                
            default:
                break;
        }
    }
    iel[0] = ia[0];
    iel[1] = @(([ia[0]intValue] + [ia[1] intValue]));
    iel[2] = @(([ia[1]intValue] + [ia[2] intValue]));
    iel[3] = ia[2];
    if ([iel[1] intValue] >= 10) {
        iel[1] = @([iel[1] intValue] - 10);
    }
    if ([iel[2] intValue] >= 10) {
        iel[2] = @([iel[2] intValue] - 10);
    }
    arrString = [Getdate(iel) mutableCopy];
    iell[0] = arrString[0];
    iell[1] = arrString[1];
    iell[2] = arrString[2];
    iell[3] = arrString[3];
    NSInteger sumd = [ie[0]intValue] + [ie[1]intValue] + [ie[2]intValue] + [ie[3]intValue] + [ie[4]intValue] + [ie[5]intValue];
    NSInteger flag = (sumd % 2);
				if (flag == 0) {
                    [mimaString appendFormat:@"%@%@%@%@%@%@%@%@%@%@", iell[0], ie[0], iell[2], ie[2], iell[1], ie[4], ie[5], iell[3] , ie[1] , ie[3]];
                } else if (flag == 1) {
                    [mimaString appendFormat:@"%@%@%@%@%@%@%@%@%@%@",iell[2], ie[3] , ie[1], ie[2],iell[0], ie[5], iell[1], ie[0], iell[3],ie[4]];
                }
    return mimaString;
}

+ (NSString *)getDate:(NSString *)string {
    NSString *dateString = [string substringWithRange:NSMakeRange(12, 3)];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[dateString floatValue] * 60 * 60 * 24];
//    NSLog(@"%@", [self getCurrTime:date]);
    return [self getCurrTime:date];
}

+ (NSString *)getCurrTime:(NSDate *)date  {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

//获取密码和时间
+ (void)getParsswordWithString:(NSString *)string withDateBlock:(void(^)(NSString *a,NSString *b))blcok {
    if (string.length != 15) {
        [self popAlertView:@"请检查输入是否有误"];
        return ;
    }
    
    //到期时间
    NSString *deadlineDate = [self getDate:string];
    
    //主板编号
    NSString *productSerialNumber = [string substringWithRange:NSMakeRange(6, 6)];
    
    //查询是否存在
    NSString *paswod = [TheDatabaseManager searchFromTableName:JIESUOTABELNAME withKey:@"productSerialNumber" andObjece:productSerialNumber];
    
    if (paswod.length) {
        
        blcok([NSString stringWithFormat:@"到期时间: %@", deadlineDate],[NSString stringWithFormat:@"解锁码: %@ %@ %@", [[self stringWithText:[string stringByReplacingOccurrencesOfString:productSerialNumber withString:paswod]]substringWithRange:NSMakeRange(0, 3)], [[self stringWithText:[string stringByReplacingOccurrencesOfString:productSerialNumber withString:paswod]]substringWithRange:NSMakeRange(3, 4)],[[self stringWithText:[string stringByReplacingOccurrencesOfString:productSerialNumber withString:paswod]]substringWithRange:NSMakeRange(6, 3)]]);
        ProductClass *p = [ProductClass new];
        p.productSerialNumber = productSerialNumber;
        p.dateOld = deadlineDate;
        [TheDatabaseManager update:JIESUOTABELNAME installObject:p];
        
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WXPayView *view = [[WXPayView alloc] initWithMoney:productSerialNumber  cardMessage:@"上海滨捷机电有限公司." completion:^(NSString *password) {
//                NSLog(@"输入的密码是%@",password); // 密码输入完成回调
                ProductClass *pc = [ProductClass new];
                pc.productPassword = password;
                pc.productSerialNumber = productSerialNumber;
                pc.dateOld = deadlineDate;
                [TheDatabaseManager addObjectDataWithTableName:JIESUOTABELNAME installObject:pc withAlerFlag:NO];
                [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
                }];
                blcok([NSString stringWithFormat:@"到期时间: %@", deadlineDate],[NSString stringWithFormat:@"解锁码: %@ %@ %@", [[self stringWithText:[string stringByReplacingOccurrencesOfString:productSerialNumber withString:password]]substringWithRange:NSMakeRange(0, 3)], [[self stringWithText:[string stringByReplacingOccurrencesOfString:productSerialNumber withString:password]]substringWithRange:NSMakeRange(3, 4)],[[self stringWithText:[string stringByReplacingOccurrencesOfString:productSerialNumber withString:password]]substringWithRange:NSMakeRange(6, 3)]]);
            }];
            __weak WXPayView *weakView = view;
            view.exitBtnClicked = ^{ // 点击了退出按钮
                [weakView hidden];
            };
            
            
            [view show];
        });
        
        
//        return nil;
    }
   
}

+ (void)popAlertView:(NSString *)str {
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"小提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"重新输入~", nil];
    al.delegate = self;
    [al show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

@end
