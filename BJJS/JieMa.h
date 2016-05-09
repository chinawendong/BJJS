//
//  JieMa.h
//  BingJieJiDian
//
//  Created by Pop Web on 15/9/2.
//  Copyright (c) 2015年 滨捷机电. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JieMa : NSObject

+ (NSString *)stringWithText:(NSString *)string;
+ (NSString *)getDate:(NSString *)string;

+ (void)getParsswordWithString:(NSString *)string withDateBlock:(void(^)(NSString *a,NSString *b))blcok;
@end
