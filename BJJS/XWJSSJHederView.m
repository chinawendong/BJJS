//
//  XWJSSJHederView.m
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/18.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "XWJSSJHederView.h"

@implementation XWJSSJHederView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithTitle:@"主板编号" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]initWithTitle:@"主板密码" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *bar3 = [[UIBarButtonItem alloc]initWithTitle:@"到期日期" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *bar4 = [[UIBarButtonItem alloc]initWithTitle:@"出厂日期" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *bar5 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.items = @[ bar1, bar5, bar2,bar5, bar3, bar5, bar4];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
