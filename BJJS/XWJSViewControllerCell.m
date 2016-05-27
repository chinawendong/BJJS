//
//  XWJSViewControllerCell.m
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/18.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "XWJSViewControllerCell.h"

#import "ProductClass.h"

@interface XWJSViewControllerCell ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar2;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *arrayItem;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *arrayItem2;

@end

@implementation XWJSViewControllerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ProductClass *)pr {

    [self.arrayItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBarButtonItem *item = (UIBarButtonItem *)obj;
        switch (idx) {
            case 0:
                item.title = pr.productSerialNumber;
                break;
            case 1:
                item.title = pr.productPassword;
                break;
            case 2:
                item.title = pr.dateOld.length ? pr.dateOld : [NSString stringWithFormat:@"-"];
                break;
            case 3:
                item.title = pr.productDeliveryTime.length ? pr.productDeliveryTime : [NSString stringWithFormat:@"-"];
                break;
            default:
                break;
        }
    }];
    
    [self.arrayItem2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBarButtonItem *item = (UIBarButtonItem *)obj;
        switch (idx) {
            case 0:
                item.title = pr.productAgent;
                break;
            case 1:
                item.title = pr.productServiceName;
                break;
            case 2:
                item.title = pr.productDecryptionPersonnel;
                break;
            case 3:
                item.title = pr.productPhoneNumber;
                break;
            default:
                break;
        }
    }];
    
    switch ([pr getCurrTime]) {
        case XWDateOldStatueNone:
            
            break;
        case XWDateOldStatueWillPast:
        case XWDateOldStatueDidPast:
            self.toolbar.barTintColor = [UIColor redColor];
            self.toolbar2.barTintColor = [UIColor redColor];
            
            break;
        default:
            break;
    }
}

@end
