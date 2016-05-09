//
//  ProductClass.h
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/15.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
//是否过期或者快过期
typedef enum : NSUInteger {
    XWDateOldStatueNone,
    XWDateOldStatueWillPast,
    XWDateOldStatueDidPast,
} XWDateStatue;

@interface ProductClass : NSObject

//编号
@property (nonatomic, copy) NSString *productSerialNumber;
//密码
@property (nonatomic, copy) NSString *productPassword;
//出库时间
@property (nonatomic, copy) NSString *productDeliveryTime;
//代理商
@property (nonatomic, copy) NSString *productAgent;
//客户名称
@property (nonatomic, copy) NSString *productServiceName;
//解密人员
@property (nonatomic, copy) NSString *productDecryptionPersonnel;
//电话
@property (nonatomic, copy) NSString *productPhoneNumber;
//到期日期
@property (nonatomic, copy) NSString *dateOld;
//多余参数 过滤
@property (nonatomic, copy) NSString *guolv;
//@property (nonatomic, assign) XWDateStatue statue;

- (XWDateStatue)getCurrTime;
@end
