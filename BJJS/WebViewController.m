//
//  WebViewController.m
//  BJJS
//
//  Created by 温仲斌 on 16/3/28.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "WebViewController.h"
#import "ProjiectCache.h"

#import <AFNetworking.h>

#import <UIProgressView+AFNetworking.h>

@interface WebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSString *urlString = self.urlString;
    
    NSString *titleStr = [urlString componentsSeparatedByString:@"\\"].lastObject;
    NSLog(@"%@", @([[ProjiectCache new]fileExistsWithPath:titleStr]));
    ProjiectCache *cache = [ProjiectCache new];
    [cache fileExistsWithPath:titleStr] ? ({
        NSURL *url = [NSURL fileURLWithPath:[cache.userPath stringByAppendingPathComponent:titleStr]];
        NSLog(@"%@", url);
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }) : ({
        
        urlString = [[urlString stringByReplacingOccurrencesOfString:@"C:\\websoft\\tomcat70\\webapps" withString:@"http://121.40.236.160:8080"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *URL = [NSURL URLWithString:encodedString];
        UIProgressView *pro = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 1)];
        [self.view addSubview:pro];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            [pro removeFromSuperview];
            [self.webView loadRequest:[NSURLRequest requestWithURL:filePath]];
            
        }];
        
        [pro setProgressWithDownloadProgressOfTask:downloadTask animated:YES];
        [downloadTask resume];
        
    });
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
//        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
