#import "PassCell.h"

#import "XWTextFiledScrollView.h"

#import "ProductClass.h"

@interface PassCell()<UITextFieldDelegate>
{
	CGFloat _shadowWidth;
}

@property (weak, nonatomic) IBOutlet UILabel *dailishang;
@property (weak, nonatomic) IBOutlet UILabel *password;
@property (weak, nonatomic) IBOutlet UILabel *kefu;
@property (weak, nonatomic) IBOutlet UILabel *chukushijian;
@property (weak, nonatomic) IBOutlet UILabel *daoqishijian;
@property (weak, nonatomic) IBOutlet UILabel *jiemirenyuan;
@property (weak, nonatomic) IBOutlet UILabel *dianhuahaoma;
@property (weak, nonatomic) IBOutlet XWTextFiledScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *guoqi;

@end

@implementation PassCell

- (void)layoutSubviews
{
	[super layoutSubviews];
//    [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
	CGRect bounds = self.bounds;
	if (_shadowWidth != bounds.size.width)
	{
		if (_shadowWidth == 0)
		{
			[self.layer setMasksToBounds:NO ];
			[self.layer setShadowColor:[[UIColor blackColor ] CGColor ] ];
			[self.layer setShadowOpacity:0.5 ];
			[self.layer setShadowRadius:5.0 ];
			[self.layer setShadowOffset:CGSizeMake( 0 , 0 ) ];
			self.layer.cornerRadius = 5.0;
		}
		[self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:bounds ] CGPath ] ];
		_shadowWidth = bounds.size.width;
	}
}

- (void)flipTransitionWithOptions:(UIViewAnimationOptions)options halfway:(void (^)(BOOL finished))halfway completion:(void (^)(BOOL finished))completion
{
	CGFloat degree = (options & UIViewAnimationOptionTransitionFlipFromRight) ? -M_PI_2 : M_PI_2;
	
	CGFloat duration = 0.4;
	CGFloat distanceZ = 2000;
	CGFloat translationZ = self.frame.size.width / 2;
	CGFloat scaleXY = (distanceZ - translationZ) / distanceZ;
	
	CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
	rotationAndPerspectiveTransform.m34 = 1.0 / -distanceZ; // perspective
	rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0, 0, translationZ);
	
	rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, scaleXY, scaleXY, 1.0);
	self.layer.transform = rotationAndPerspectiveTransform;
	
	[UIView animateWithDuration:duration / 2 animations:^{
		self.layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, degree, 0.0f, 1.0f, 0.0f);
	} completion:^(BOOL finished){
		if (halfway) halfway(finished);
		self.layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, -degree, 0.0f, 1.0f, 0.0f);
		[UIView animateWithDuration:duration / 2 animations:^{
			self.layer.transform = rotationAndPerspectiveTransform;
		} completion:^(BOOL finished){
			self.layer.transform = CATransform3DIdentity;
			if (completion) completion(finished);
		}];
	}];
}

- (void)setData:(ProductClass *)p {
    self.productObject = p;
    _titleLabel.text = [NSString stringWithFormat:@"主板编号: %@", p.productSerialNumber];
    
    switch ([p getCurrTime]) {
        case XWDateOldStatueNone:
            _titleLabel.textColor = [UIColor darkGrayColor];
            _guoqi.hidden = YES;
            break;
        case XWDateOldStatueWillPast:
            _titleLabel.textColor = [UIColor redColor];
            _guoqi.hidden = NO;
            _guoqi.text = @"即将过期";
            break;
        case XWDateOldStatueDidPast:
            _titleLabel.textColor = [UIColor redColor];
            _guoqi.hidden = NO;
            _guoqi.text = @"已过期";
            break;
        default:
            break;
    }

    
    
    [_textFields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *t = obj;
        switch (t.tag) {
            case 101:
                t.text = p.productAgent;
                break;
            case 102:
                t.text = p.productPassword;
                break;
            case 103:
                t.text = p.productServiceName;
                break;
            case 104:
                t.text = p.productDeliveryTime;
                break;
            case 105:
                t.text = p.dateOld;
                break;
            case 106:
                t.text = p.productDecryptionPersonnel;
                break;
            case 107:
                t.text = p.productPhoneNumber;
                break;
                
            default:
                break;
        }
    }];
}

@end
