#import <UIKit/UIKit.h>

@class ProductClass;

@interface PassCell : UICollectionViewCell

@property (nonatomic ,strong) ProductClass *productObject;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UIButton *infoButton;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

- (void)flipTransitionWithOptions:(UIViewAnimationOptions)options halfway:(void (^)(BOOL finished))halfway completion:(void (^)(BOOL finished))completion;

- (void)setData:(ProductClass *)p;

@end
