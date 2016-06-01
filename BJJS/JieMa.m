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

@interface JieMa ()<UIAlertViewDelegate>{
   
    
}
@property (nonatomic,copy)  NSString *deadlineDate;
@property (nonatomic,copy) NSString *productSerialNumber;
@property (nonatomic,copy) NSString *string;
@property (nonatomic,copy) void (^jieMaBlock)();
@property (nonatomic,copy) void (^block)(NSString *a,NSString *b,ProductClass *obj);

@end

@implementation JieMa

+ (instancetype)shaerJieMa {
    static JieMa *jiema;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jiema = [self new];
    });
    return jiema;
}

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
    
    return [self getCurrTime:date];
}

/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
+ (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    switch (week) {
        case 1:
            return @"  星期天";
            break;
        case 2:
            return @"  星期一";
            break;
        case 3:
            return @"  星期二";
            break;
        case 4:
            return @"  星期三";
            break;
        case 5:
            return @"  星期四";
            break;
        case 6:
            return @"  星期五";
            break;
        case 7:
            return @"  星期六";
            break;
            
        default:
            break;
    }
    return nil;
}

/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
+ (NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
        NSLog(@"0天0小时0分钟");
        return 0;
    }
    else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}

// 获取当前是星期几
+ (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
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
+ (void)getParsswordWithString:(NSString *)string withDateBlock:(void(^)(NSString *a,NSString *b, ProductClass *obj))blcok {
    if (string.length != 15) {
        [self popAlertView:@"请检查输入是否有误"];
        return ;
    }
    JieMa *m = [JieMa shaerJieMa];
    m.string = string;
    //到期时间
    m.deadlineDate = [self getDate:string];
    
    //主板编号
    m.productSerialNumber = [string substringWithRange:NSMakeRange(6, 6)];
    //查询是否存在
    NSArray *p = [TheDatabaseManager searchFromTableName:JIESUOTABELNAME withKey:@"productSerialNumber" andObjece:m.productSerialNumber];
    if (p.count) {
        ProductClass *p1 = p.firstObject;
        NSString *paswod = p1.productPassword;
        if (paswod.length) {
            NSString *newSteing = [JieMa stringWithText:[m.string stringByReplacingOccurrencesOfString:m.productSerialNumber withString:paswod]];
            NSString *fistr = [newSteing substringWithRange:NSMakeRange(0, 2)];
            NSString *two = [newSteing substringWithRange:NSMakeRange(2, 4)];
            NSString *three = [newSteing substringWithRange:NSMakeRange(6, 4)];
            
            NSString *s = [NSString stringWithFormat:@"解锁码: %@ %@ %@", fistr,two,three];
            
            blcok([NSString stringWithFormat:@"到期时间: %@", m.deadlineDate],s,p1);
            ProductClass *p = [ProductClass new];
            p.productSerialNumber = m.productSerialNumber;
            p.dateOld = m.deadlineDate;
            [TheDatabaseManager update:JIESUOTABELNAME installObject:p];
            
        }else {
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:m.productSerialNumber message:@"对应密码:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            al.alertViewStyle = UIAlertViewStyleSecureTextInput;
            al.tag = 1000001;
            al.delegate = [JieMa shaerJieMa];
            [al show];
            [JieMa shaerJieMa].block = blcok;
        }
    }else {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:m.productSerialNumber message:@"对应密码:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.alertViewStyle = UIAlertViewStyleSecureTextInput;
        al.tag = 1000001;
        al.delegate = [JieMa shaerJieMa];
        [al show];
        [JieMa shaerJieMa].block = blcok;
    }
   
}

+ (void)popAlertView:(NSString *)str {
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"小提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"重新输入~", nil];
    [al show];
}

+ (void)popAlertView2:(NSString *)str {
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"小提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"重新输入~", nil];
    al.tag = 10002;
    al.delegate = [self shaerJieMa];
    [al show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000001 && buttonIndex) {
        NSString *string = [alertView textFieldAtIndex:0].text;
        if (string.length < 6) {
            [JieMa popAlertView2:@"密码格式不正确"];
            return;
        }
        ProductClass *pc = [ProductClass new];
        pc.productPassword = string;
        pc.productSerialNumber = self.productSerialNumber;
        pc.dateOld = self.deadlineDate;
        [TheDatabaseManager addObjectDataWithTableName:JIESUOTABELNAME installObject:pc oldObject:nil withAlerFlag:NO];
        [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        }];
        NSString *s = [NSString stringWithFormat:@"解锁码: %@ %@ %@", [[JieMa stringWithText:[_string stringByReplacingOccurrencesOfString:self.productSerialNumber withString:string]]substringWithRange:NSMakeRange(0, 2)], [[JieMa stringWithText:[_string stringByReplacingOccurrencesOfString:self.productSerialNumber withString:string]]substringWithRange:NSMakeRange(2, 4)],[[JieMa stringWithText:[_string stringByReplacingOccurrencesOfString:self.productSerialNumber withString:string]]substringWithRange:NSMakeRange(6, 4)]];
        self.block([NSString stringWithFormat:@"到期时间: %@", self.deadlineDate],s,nil);
    }
    if (alertView.tag == 10002) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:self.productSerialNumber message:@"对应密码:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.alertViewStyle = UIAlertViewStyleSecureTextInput;
        al.tag = 1000001;
        al.delegate = [JieMa shaerJieMa];
        [al show];

    }
}

@end
