//
//  JieSuoView.m
//  BJJS
//
//  Created by 温仲斌 on 16/2/17.
//  Copyright © 2016年 温仲斌. All rights reserved.
//

#import "JieSuoView.h"

#import "UIColor+HexString.h"

#import "JieMa.h"

#import "TheDatabaseManager.h"

#import "MacroManger.h"

#import "ProductClass.h"

#import "XWJSViewController.h"

#import "JieSuoViewController.h"

#import "AddNewViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface XWScrollView : UIScrollView

@property (nonatomic, strong)  NSTimer *timer;

@end

@implementation XWScrollView{
   UIScrollView *showView ;
   CGRect rect;
}
@synthesize timer;

- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      // 获取文本
      NSString *string = @"请输入6位随机数 如:123456 加主板编号 如:888888 加日期 如:030为30天。";
      rect = [string boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
      
      // 初始化label
      UILabel *label	  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), 20)];
      label.text		  = string;
      label.textColor = [UIColor lightGrayColor];
      label.numberOfLines = 0;
      label.userInteractionEnabled = YES;
      
      UILabel *label2	  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(rect), 0, CGRectGetWidth(rect), 20)];
      label2.text		  = string;
      label2.textColor = [UIColor lightGrayColor];
      label2.numberOfLines = 0;
      label2.userInteractionEnabled = YES;
      
      label2.font = [UIFont systemFontOfSize:13];
      label.font = [UIFont systemFontOfSize:13];
      
      self.contentSize   = CGSizeMake(2 * CGRectGetWidth(rect), 0);
      self.pagingEnabled = YES;
      self.showsVerticalScrollIndicator = NO;
      [self addSubview:label];
      [self addSubview:label2];
      
      timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(change) userInfo:nil repeats:YES];
   }
   return self;
}

- (void)change {
   CGFloat offset = self.contentOffset.x + 30;
   
   if(offset >= 2 * CGRectGetWidth(rect) - CGRectGetWidth([UIScreen mainScreen].bounds)) {
      self.contentOffset = CGPointMake(0, 0);
      offset = 30;
   }
   [UIView animateWithDuration:1 animations:^{
      [UIView setAnimationCurve:UIViewAnimationCurveLinear];
      self.contentOffset = CGPointMake(offset, 0);
   }];
}

- (void)dealloc {
   if (timer) {
      [timer invalidate];
      timer = nil;
   }
}


@end


@implementation XWTextField

- (void)drawRect:(CGRect)rect {
   UIBezierPath *be = [UIBezierPath bezierPath];
   [be moveToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - 4)];
   [be addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
   [be addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.frame))];
   [be addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.frame) - 4)];
   [[UIColor colorWithHexString:@"#55AAFF"]set];
   [be setLineWidth:2];
   [be stroke];
   
   [super drawRect:rect];
}

@end

@interface JieSuoView ()<UITextFieldDelegate>

@property (nonatomic) CGFloat boardHigth;

@end

@implementation JieSuoView{
   UILabel *dailishang;
   UILabel *yonghu;
   UILabel *chuhuoshijian;
   UILabel *xinghao;
   UILabel *daohuoshijian;
   UILabel *jiesuoma;
   XWTextField *textField;
}


- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showBoy:) name:UIKeyboardWillShowNotification object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBoy:) name:UIKeyboardWillHideNotification object:nil];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResign)];
      [self addGestureRecognizer:tap];
      [self setupUI];
   }
   return self;
}

- (void)tapResign {
   [textField resignFirstResponder];
}

- (void)showBoy:(NSNotification *)n {
   CGRect recg = [n.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
   self.boardHigth = CGRectGetHeight(recg);
}

- (void)hideBoy:(NSNotification *)n {
   self.transform = CGAffineTransformIdentity;
}

- (void)textFieldDidBeginEditing:(UITextField *)textFields {
   if (!_boardHigth) {
      _boardHigth = 253;
   }
   textFields.frame.origin.y + CGRectGetHeight(textFields.frame) + _boardHigth + 20 - CGRectGetHeight([UIScreen mainScreen].bounds) > 0 ? [UIView animateWithDuration:.2 animations:^{
      self.transform = CGAffineTransformMakeTranslation(0, -(textFields.frame.origin.y + CGRectGetHeight(textFields.frame) + _boardHigth + 20 - CGRectGetHeight([UIScreen mainScreen].bounds)));
   }] : nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFields {
   [textFields resignFirstResponder];
   [JieMa getParsswordWithString:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] withDateBlock:^(NSString *str, NSString *string) {
      daohuoshijian.text = str;
      jiesuoma.text =  string;
   }];
   return YES;
}

- (BOOL)textField:(UITextField *)textFields shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   if ([textFields.text stringByReplacingOccurrencesOfString:@" " withString:@""].length + 1 == 15 && ![string isEqualToString:@" "] && string.length) {
      [textFields resignFirstResponder];

      [JieMa getParsswordWithString:[NSString stringWithFormat:@"%@%@", [textFields.text stringByReplacingOccurrencesOfString:@" " withString:@""],string] withDateBlock:^(NSString *str, NSString *string) {
         daohuoshijian.text = str;
         jiesuoma.text =  string;
      }];
      
      textFields.text = [NSString stringWithFormat:@"%@ %@ %@", [[NSString stringWithFormat:@"%@%@", [textFields.text stringByReplacingOccurrencesOfString:@" " withString:@""],string] substringWithRange:NSMakeRange(0, 6)],[[NSString stringWithFormat:@"%@%@", [textFields.text stringByReplacingOccurrencesOfString:@" " withString:@""],string] substringWithRange:NSMakeRange(6, 6)],[[NSString stringWithFormat:@"%@%@", [textFields.text stringByReplacingOccurrencesOfString:@" " withString:@""],string] substringWithRange:NSMakeRange(12, 3)]];
   }
   return YES;
}

- (void)setupUI {
   dailishang = [UILabel new];
   yonghu = [UILabel new];
   xinghao = [UILabel new];
   chuhuoshijian = [UILabel new];
   daohuoshijian = [UILabel new];
   jiesuoma = [UILabel new];
   
   UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-icon-plane"]];
   image.translatesAutoresizingMaskIntoConstraints = NO;
   [self addSubview:image];
   UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
   [self addSubview:bu];
   bu.bounds = CGRectMake(0, 0, 44, 44);
   bu.translatesAutoresizingMaskIntoConstraints = NO;
   [bu addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
   
   textField = [XWTextField new];
   textField.clearButtonMode = UITextFieldViewModeWhileEditing;
   textField.placeholder = @"例:123456 888888 123";
   textField.delegate = self;
   textField.keyboardType = UIKeyboardTypeNumberPad;
   [self addSubview:textField];
   textField.translatesAutoresizingMaskIntoConstraints = NO;
   
   XWScrollView *scrollView = [[XWScrollView alloc]initWithFrame:CGRectZero];
   scrollView.translatesAutoresizingMaskIntoConstraints = NO;
   [self addSubview:scrollView];
   
   UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
   addButton.translatesAutoresizingMaskIntoConstraints = NO;
   [addButton setTitleColor:[UIColor colorWithHexString:@"#55AAFF"] forState:UIControlStateNormal];
   [addButton setTitle:@"添加数据" forState:UIControlStateNormal];
   addButton.layer.cornerRadius = 5;
   addButton.layer.borderColor = [UIColor colorWithHexString:@"#55AAFF"].CGColor;
   addButton.layer.masksToBounds = YES;
   addButton.layer.borderWidth = 1;
   [self addSubview:addButton];
   
   UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
   selectButton.translatesAutoresizingMaskIntoConstraints = NO;
   [selectButton setTitleColor:[UIColor colorWithHexString:@"#55AAFF"] forState:UIControlStateNormal];
   [selectButton setTitle:@"查找全部" forState:UIControlStateNormal];

   selectButton.layer.cornerRadius = 5;
   selectButton.layer.borderColor = [UIColor colorWithHexString:@"#55AAFF"].CGColor;
   selectButton.layer.masksToBounds = YES;
   selectButton.layer.borderWidth = 1;
   [self addSubview:selectButton];
   
   
   [selectButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
   [addButton addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];

   
   NSArray *array = @[dailishang,yonghu,chuhuoshijian,xinghao,daohuoshijian,jiesuoma];
   NSArray *arrayTitle = @[@"代理商:", @"用户:", @"出货时间:", @"型号:", @"到期时间:", @"解锁码:"];
   [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      [self addSubview:obj];
      UILabel *la = obj;
      la.text = arrayTitle[idx];
      la.translatesAutoresizingMaskIntoConstraints = NO;
   }];
   NSMutableArray *tmp = [NSMutableArray array];
   //代理商
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-84-[dailishang(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dailishang)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[dailishang(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dailishang)]];
   //用户
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dailishang]-15-[yonghu(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dailishang,yonghu)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[chuhuoshijian]-15-[yonghu(>=10)]-(>=5)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chuhuoshijian,yonghu)]];
   //型号
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[yonghu]-15-[xinghao(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(yonghu,xinghao)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[daohuoshijian]-15-[xinghao(>=10)]-(>=5)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(daohuoshijian,xinghao)]];
   //出货时间
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dailishang]-15-[chuhuoshijian(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(dailishang,chuhuoshijian)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[chuhuoshijian(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chuhuoshijian)]];
   //到期时间
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[chuhuoshijian]-15-[daohuoshijian(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chuhuoshijian,daohuoshijian)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[daohuoshijian(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(daohuoshijian)]];
   //解锁码
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[daohuoshijian]-15-[jiesuoma(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(daohuoshijian,jiesuoma)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[jiesuoma(>=10)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(jiesuoma)]];
   
   //解锁输入框
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[jiesuoma]-25-[textField(25)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(jiesuoma,textField)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[textField]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
   
   //提示label
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textField]-5-[scrollView(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textField,scrollView)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
   
   //添加按钮
   CGFloat buttonWith = (CGRectGetWidth([UIScreen mainScreen].bounds) - 30) / 2;
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView]-10-[addButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView,addButton)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-10-[addButton(%@)]", @(buttonWith)] options:0 metrics:nil views:NSDictionaryOfVariableBindings(addButton)]];
   
   //查找按钮
   
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView]-10-[selectButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView,selectButton)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[addButton]-10-[selectButton(%@)]-10-|", @(buttonWith)] options:0 metrics:nil views:NSDictionaryOfVariableBindings(addButton, selectButton)]];
   
   //分享
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[xinghao]-15-[bu(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(xinghao,bu)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bu(60)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bu)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[xinghao]-15-[image(20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(xinghao,image)]];
   [tmp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(20)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(image)]];
   
   [self addConstraints:tmp];
   [self layoutIfNeeded];
}

- (void)tap {
   NSLog(@"点击了 分享");
   //1、创建分享参数
//   NSArray* imageArray = @[[UIImage imageNamed:@"iconfont-category-2"]];
   //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//   if (imageArray) {
   
      NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
      [shareParams SSDKSetupShareParamsByText:jiesuoma.text
                                       images:nil
                                          url:[NSURL URLWithString:@"http://www.jdzj.com/shop/dynamic-464241.html"]
                                        title:@"分享标题"
                                         type:SSDKContentTypeAuto];
      //2、分享（可以弹出我们的分享菜单和编辑界面）
      [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                               items:nil
                         shareParams:shareParams
                 onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                    
                    switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                              message:nil
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"确定"
                                                                    otherButtonTitles:nil];
                          [alertView show];
                          break;
                       }
                       case SSDKResponseStateFail:
                       {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                          message:[NSString stringWithFormat:@"%@",error]
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil, nil];
                          [alert show];
                          break;
                       }
                       default:
                          break;
                    }
                 }
       ];
}

- (void)add {
   JieSuoViewController *xw = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardViewController"];
   [self pushViewController:xw];
}

- (void)select{
   AddNewViewController *add = [[AddNewViewController alloc]init];
   [self pushViewController:add];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
