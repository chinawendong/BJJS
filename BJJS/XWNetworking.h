//
//  XWNetworking.h
//  BJJS
//
//  Created by 温仲斌 on 16/2/23.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWNetworking : NSObject
+ (void)postNetworkingPostString:(NSString *)postString parameters:(NSDictionary *)parameters success:(void (^)(id data))success  failure:(void (^)(NSError *error))failure;
+ (void)postNetworkingPostString2:(NSString *)postString parameters:(NSDictionary *)parameters success:(void (^)(id data))successBlock  failure:(void (^)(NSError *error))failureBlock;
+ (void)postNetworkingPostString3:(NSString *)postString parameters:(NSDictionary *)parameters success:(void (^)(id data))successBlock  failure:(void (^)(NSError *error))failureBlock;
@end
