//
//  ProductClass.m
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/15.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "ProductClass.h"

@implementation ProductClass

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (ProductClass *)productClassWithDictionary:(NSDictionary *)dic {
    return [[self alloc]initWithDictionary:dic];
}

- (NSString *)dateOld {
    if ([_dateOld isEqualToString:@"(null)"] || !_dateOld.length) {
        _dateOld = @"    ";
    }
//    [self getCurrTime:nil];
    return _dateOld;
}

- (NSString *)productAgent {
    if ([_productAgent isEqualToString:@"(null)"] || !_productAgent.length) {
        _productAgent = @"    ";
    }
    return _productAgent;
}

- (NSString *)productServiceName {
    if ([_productServiceName isEqualToString:@"(null)"] || !_productServiceName.length) {
        _productServiceName = @"    ";
    }
    return _productServiceName;
}

- (NSString *)productDecryptionPersonnel {
    if ([_productDecryptionPersonnel isEqualToString:@"(null)"] || !_productDecryptionPersonnel.length) {
        _productDecryptionPersonnel = @"    ";
    }
    return _productDecryptionPersonnel;
}

- (NSString *)productPhoneNumber {
    if ([_productPhoneNumber isEqualToString:@"(null)"] || !_productPhoneNumber.length) {
        _productPhoneNumber = @"    ";
    }
    return _productPhoneNumber;
}

//- (XWDateStatue)statue {
//    return [self getCurrTime:_dateOld];
//}

- (NSString *)productDeliveryTime {
    if ([_productDeliveryTime isEqualToString:@"(null)"] || !_productDeliveryTime.length) {
        _productDeliveryTime = @"    ";
    }
    return _productDeliveryTime;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@", _productSerialNumber,_productPassword,_productDeliveryTime,_productServiceName,_productAgent];
}

- (XWDateStatue)getCurrTime  {
    if ([_dateOld isEqualToString:@"----"]) {
        return XWDateOldStatueNone;
    }
    NSString *dateStr= _dateOld;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeInterval timeInterval = [fromdate timeIntervalSinceDate:[NSDate new]];
    if (timeInterval <= 3 * 24 * 60 * 60 && timeInterval >= 0) {
        return XWDateOldStatueWillPast;
    }else if(timeInterval < 0){
        return XWDateOldStatueDidPast;
    }
    return XWDateOldStatueNone;
}

@end
