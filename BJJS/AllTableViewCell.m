//
//  AllTableViewCell.m
//  BJJS
//
//  Created by 云族佳 on 16/5/27.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "AllTableViewCell.h"

#import <Masonry.h>

@interface AllTableViewCell ()

@property (nonatomic,strong) UILabel *l1;
@property (nonatomic,strong) UILabel *l2;
@property (nonatomic,strong) UILabel *l3;
@property (nonatomic,strong) UILabel *l4;
@property (nonatomic,strong) UILabel *l5;
@property (nonatomic,strong) UILabel *l6;
@property (nonatomic,strong) UILabel *l7;
@property (nonatomic,strong) UILabel *l8;
@property (nonatomic,strong) UILabel *l9;

@end

@implementation AllTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
