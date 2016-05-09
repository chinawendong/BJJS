//
//  ProjiectCache.m
//  Heard the news
//
//  Created by Pop Web on 15/10/21.
//  Copyright © 2015年 泡果网络. All rights reserved.
//

#import "ProjiectCache.h"

#define MANAGER [NSFileManager defaultManager]

@implementation ProjiectCache

- (void)installHaoYouArray:(NSArray *)arrar withType:(BOOL)isHaoYou {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *path              = isHaoYou ? self.haoYouCachePath : self.userCenterCachePath;
        if (![MANAGER fileExistsAtPath:path]) {
            [MANAGER createFileAtPath:path contents:nil attributes:nil];
        }
        [arrar writeToFile:path atomically:YES] ? NSLog(@"成功") : NSLog(@"失败");
    });
}

- (void)installData:(NSURL *)data withPath:(NSString *)pathString {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *path              = [self.dataPath stringByAppendingString:pathString];
        if (![MANAGER fileExistsAtPath:path]) {
            [MANAGER createFileAtPath:path contents:nil attributes:nil];
        }
        [MANAGER moveItemAtURL:data toURL:[NSURL fileURLWithPath:path] error:nil] ?  NSLog(@"成功") : NSLog(@"失败");
    });
}

- (BOOL)fileExistsWithPath:(NSString *)path {
    NSString *paths;

    NSFileManager *myFileManager=[NSFileManager defaultManager];
  

    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:[self userPath]];
    BOOL flag = NO;
    while((paths = [myDirectoryEnumerator nextObject])!=nil)
        
    {
        
        if ([path isEqualToString:paths]) {
            flag = YES;
        }

        
    }
    return flag;
}

- (NSString *)haoYouCachePath {
    return [NSString stringWithFormat:@"%@/Library/Caches/binjieziliao",NSHomeDirectory()];
}

- (NSString *)userCenterCachePath {
    return [NSString stringWithFormat:@"%@/Library/Caches/xitongziliao",NSHomeDirectory()];
}

- (NSString *)userPath {
    return [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
}

- (NSString *)dataPathd {
    return [NSString stringWithFormat:@"%@/Library/Caches/data",NSHomeDirectory()];
}

- (NSDictionary *)titleDictionary {
    return @{@"XinDai" : @"新代", @"XiMenZi" : @"西门子", @"SanLing" : @"三菱", @"FaNaKe" : @"发那科" , @"FaGe" : @"发格" , @"BaoYuan" : @"宝元"};
}

- (NSArray *)getCacheArrayWithPath:(BOOL)isHaoYou {

    NSString *path              = isHaoYou ? self.haoYouCachePath : self.userCenterCachePath;
    NSArray *array              = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@", self.haoYouCachePath);

    return array;
}

- (void)removeAllProjiectCache:(BOOL)isFlag {
    dispatch_async(dispatch_get_main_queue(), ^{
        isFlag ?
        [MANAGER removeItemAtPath:self.haoYouCachePath error:nil]:
        [MANAGER removeItemAtPath:self.userCenterCachePath error:nil];
    });
}

@end
