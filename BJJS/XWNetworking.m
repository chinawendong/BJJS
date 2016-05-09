//
//  XWNetworking.m
//  BJJS
//
//  Created by 温仲斌 on 16/2/23.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "XWNetworking.h"

#import <AFNetworking.h>
//http://121.40.236.160:8080
#define URLAPI(a) [NSString stringWithFormat:@"http://121.40.236.160:8080/binjie/%@", a]

@implementation XWNetworking

+ (void)postNetworkingPostString:(NSString *)postString parameters:(NSDictionary *)parameters success:(void (^)(id data))successBlock  failure:(void (^)(NSError *error))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    postString = @"listviewServlet";
//    parameters = @{@"kouhao" : @"binjieziliao"};
    [manager POST:URLAPI(postString) parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        successBlock(jsonString);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(error);
    }];
}

+ (void)postNetworkingPostString2:(NSString *)postString parameters:(NSDictionary *)parameters success:(void (^)(id data))successBlock  failure:(void (^)(NSError *error))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:URLAPI(postString) parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        successBlock(jsonString);
        NSLog(@"%@", jsonString);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock(error);
    }];
    
}

+ (void)postNetworkingPostString3:(NSString *)postString parameters:(NSDictionary *)parameters success:(void (^)(id data))successBlock  failure:(void (^)(NSError *error))failureBlock {
    NSError *error=nil;
    NSString *url = URLAPI(postString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error=nil;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        NSMutableDictionary *jsonResponseDict= [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSLog(@"Response Dictionary:: %@",jsonResponseDict);
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

    }];
}



@end
