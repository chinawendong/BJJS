//
//  ProjiectCache.h
//  Heard the news
//
//  Created by Pop Web on 15/10/21.
//  Copyright © 2015年 泡果网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjiectCache : NSFileManager

@property (nonatomic, readonly, copy) NSString *haoYouCachePath;
@property (nonatomic, readonly, copy) NSString *userCenterCachePath;
@property (nonatomic, readonly, copy) NSString *dataPath;
@property (nonatomic, readonly, copy) NSString *userPath;
@property (nonatomic, readonly, copy) NSDictionary *titleDictionary ;

- (void)installHaoYouArray:(NSArray *)arrar withType:(BOOL)isHaoYou;
- (NSArray *)getCacheArrayWithPath:(BOOL)isHaoYou;
- (void)removeAllProjiectCache:(BOOL)isFlag;
- (void)installData:(NSURL *)data withPath:(NSString *)pathString ;
- (BOOL)fileExistsWithPath:(NSString *)path ;

@end
