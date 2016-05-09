//
//  XWTextFiledScrollView.m
//  BJJDProject
//
//  Created by 温仲斌 on 15/12/16.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import "XWTextFiledScrollView.h"

@interface XWTextFiledScrollView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *arrayTextFiled;
@property (nonatomic) CGFloat boardHigth;

@end

@implementation XWTextFiledScrollView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBoy:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBoy:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)showBoy:(NSNotification *)n {
    CGRect recg = [n.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    self.boardHigth = CGRectGetHeight(recg);
}

- (void)hideBoy:(NSNotification *)n {
    [self setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (NSMutableArray *)arrayTextFiled {
    if (!_arrayTextFiled) {
        _arrayTextFiled = [NSMutableArray array];
    }
    return _arrayTextFiled;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSMutableArray *arr = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [arr addObject:obj];
        }
    }];
    
    self.arrayTextFiled = [self compareArray:arr];
    
    for (UITextField *t  in _arrayTextFiled) {
        t.delegate = self;
    }
    
}

- (NSMutableArray *)compareArray:(NSArray *)compareArray {
    return [compareArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UITextField *text1 = obj1;
        UITextField *text2 = obj2;
        if (text1.frame.origin.y < text2.frame.origin.y) {
            return NSOrderedAscending;
        }
        if (text1.frame.origin.y == text2.frame.origin.y) {
            if (text1.frame.origin.x < text2.frame.origin.x) {
                return NSOrderedAscending;
            }
            if (text1.frame.origin.x > text2.frame.origin.x) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }
        return NSOrderedDescending;
    }].mutableCopy;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (CGRectGetHeight([UIScreen mainScreen].bounds) - textField.frame.origin.y - self.contentOffset.y < self.boardHigth + textField.frame.size.height + 128) {
        CGFloat offY = fabs(CGRectGetHeight([UIScreen mainScreen].bounds) - textField.frame.origin.y - self.contentOffset.y - self.boardHigth - textField.frame.size.height - 64);
        [self setContentOffset:CGPointMake(0, offY - self.contentOffset.y) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger idx = [_arrayTextFiled indexOfObject:textField];
    if (idx + 1 < _arrayTextFiled.count) {
        UITextField *nextTextField = _arrayTextFiled[(idx+1) % _arrayTextFiled.count];
        [nextTextField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
