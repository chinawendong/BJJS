//
//  AddNewViewControllerView.h
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/19.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductClass;

@interface AddNewViewControllerView : UIView

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) NSString *sevaTitle;
@property (nonnull, strong) ProductClass *obj;

@end
