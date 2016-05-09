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
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *arrayItem;

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
}

@end
