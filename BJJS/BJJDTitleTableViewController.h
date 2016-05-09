//
//  BJJDTitleTableViewController.h
//  BJJS
//
//  Created by 温仲斌 on 16/3/28.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BJJDTitleTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *urlArray;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSDictionary *parameters;

@end
