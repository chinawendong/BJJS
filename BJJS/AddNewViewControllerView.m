//
//  AddNewViewControllerView.m
//  BJJDProject
//
//  Created by 温仲斌 on 16/1/19.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "AddNewViewControllerView.h"

#import "XWTextFiledScrollView.h"

#import "ProductClass.h"

#import "TheDatabaseManager.h"

#import "MacroManger.h"

@interface AddNewViewControllerView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *arrayTextFiled;
@property (nonatomic) CGFloat boardHigth;
@property (weak, nonatomic) IBOutlet UITextField *zhuBan;
@property (weak, nonatomic) IBOutlet UITextField *miMa;
@property (weak, nonatomic) IBOutlet UITextField *shijian;
@property (weak, nonatomic) IBOutlet UITextField *delegateObject;
@property (weak, nonatomic) IBOutlet UITextField *kefuName;
@property (weak, nonatomic) IBOutlet UITextField *jiemirenyuan;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation AddNewViewControllerView

- (instancetype)initWithTitleArrAy:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBoy:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBoy:) name:UIKeyboardWillHideNotification object:nil];
        [self addLabelAndTextFiled:array];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBoy:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBoy:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}



- (void)addLabelAndTextFiled:(NSArray *)array {
    XWTextFiledScrollView *sc = [[XWTextFiledScrollView alloc]initWithFrame:self.frame];
    [self addSubview:sc];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
}

- (void)showBoy:(NSNotification *)n {
    CGRect recg = [n.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    self.boardHigth = CGRectGetHeight(recg);
}

- (void)hideBoy:(NSNotification *)n {
    self.transform = CGAffineTransformIdentity;
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
    textField.frame.origin.y + CGRectGetHeight(textField.frame) + _boardHigth + 10 - CGRectGetHeight([UIScreen mainScreen].bounds) > 0 ? [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -(textField.frame.origin.y + CGRectGetHeight(textField.frame) + _boardHigth + 10 - CGRectGetHeight([UIScreen mainScreen].bounds)));
    }] : nil;
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

- (IBAction)saveData:(id)sender {
    [_arrayTextFiled enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *t = obj;
        [t resignFirstResponder];
    }];
    if (_zhuBan.text.length != 6 || _miMa.text.length != 6) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的主板编号或者密码不正确" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了~", nil];
        [alertView show];
        return;
    }
    
    
    ProductClass *p = [ProductClass new];
    p.productSerialNumber = _zhuBan.text;
    p.productPassword = _miMa.text;
    p.productDeliveryTime = _shijian.text;
    p.productAgent = _delegateObject.text;
    p.productServiceName = _kefuName.text;
    p.productDecryptionPersonnel = _jiemirenyuan.text;
    p.productPhoneNumber = _phoneNumber.text;
    p.dateOld = @"----";
    [TheDatabaseManager addObjectDataWithTableName:JIESUOTABELNAME installObject:p withAlerFlag:YES];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
