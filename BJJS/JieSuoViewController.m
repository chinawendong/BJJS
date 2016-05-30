#import "JieSuoViewController.h"
#import "PassCell.h"
#import "MTCardLayout.h"
#import "UICollectionView+CardLayout.h"
#import "LSCollectionViewLayoutHelper.h"
#import "UICollectionView+Draggable.h"
#import "SearchViewController.h"

#import "AddNewViewController.h"
#import "TheDatabaseManager.h"
#import "MacroManger.h"
#import "ProductClass.h"

@interface JieSuoViewController ()<SearchViewControllerDelegate, UICollectionViewDataSource_Draggable,UITextFieldDelegate>

@property (nonatomic, strong) SearchViewController *searchViewController;
@property (nonatomic, strong) NSMutableArray * dataArray;


@end

@implementation JieSuoViewController

#pragma mark Status Bar color

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Lifecycle

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PassCell *cell = (PassCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:.5 animations:^{
        cell.infoButton.hidden = NO;
    }];
    [self.collectionView setPresenting:YES animated:YES completion:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 100000; i < 100100; i++)  {
//        [self.items addObject:[NSString stringWithFormat:@"主板编号:%d", i]];
//    }
    self.title = @"所有主板信息";
    self.searchViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    self.searchViewController.delegate = self;
	self.collectionView.backgroundView = self.searchViewController.view;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"全部资料" style:UIBarButtonItemStylePlain target:self action:@selector(addItm)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
	UIImageView *dropOnToDeleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashcan"] highlightedImage:[UIImage imageNamed:@"trashcan_red"]];
	dropOnToDeleteView.center = CGPointMake(50, 300);
	self.collectionView.dropOnToDeleteView = dropOnToDeleteView;
	
	UIImageView *dragUpToDeleteConfirmView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashcan"] highlightedImage:[UIImage imageNamed:@"trashcan_red"]];
	self.collectionView.dragUpToDeleteConfirmView = dragUpToDeleteConfirmView;
    self.dataArray = [NSMutableArray array];
    [self getData];

}

- (void)getData {
    __weak typeof(self) weakBlock = self;
    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        NSMutableArray *array = [self compareArray:arr];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductClass *p = obj;
            if ([p getCurrTime] == XWDateOldStatueDidPast || [p getCurrTime] == XWDateOldStatueWillPast) {
                [array removeObject:p];
                [array insertObject:p atIndex:0];
            }
        }];
        weakBlock.dataArray = array;
        [weakBlock.collectionView reloadData];
    }];
}

- (NSMutableArray *)compareArray:(NSArray *)compareArray {
    return [compareArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ProductClass *text1 = obj1;
        ProductClass *text2 = obj2;
        NSInteger flat1 = [[text1.productSerialNumber substringToIndex:1] integerValue];
        NSInteger flat2= [[text2.productSerialNumber substringToIndex:1] integerValue];
        if (flat1 < flat2) {
            return NSOrderedAscending;
        }
        if (flat1 == flat2) {
            return NSOrderedSame;
        }
        return NSOrderedDescending;
    }].mutableCopy;
}

- (void)addItm {
    __weak typeof(self) weakBlock = self;
    [_dataArray removeAllObjects];
    [TheDatabaseManager quaueupdataList:JIESUOTABELNAME andProperString:nil withSteing:nil andNewString:nil andClass:[ProductClass class] withBlock:^(NSArray *arr) {
        NSMutableArray *array = [self compareArray:arr];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductClass *p = obj;
            if ([p getCurrTime] == XWDateOldStatueDidPast || [p getCurrTime] == XWDateOldStatueWillPast) {
                [array removeObject:p];
                [array insertObject:p atIndex:0];
            }
        }];
        weakBlock.dataArray = array;
        [weakBlock.collectionView setPresenting:NO];
        [weakBlock.collectionView reloadData];

    }];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pass" forIndexPath:indexPath];
    cell.infoButton.hidden = self.collectionView.presenting;
    [cell setData:_dataArray[indexPath.row]];
//	cell.titleLabel.text = self.items[indexPath.item];
	return cell;
}

- (UIImage *)collectionView:(UICollectionView *)collectionView imageForDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	CGSize size = cell.bounds.size;
	size.height = 72.0;
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[cell.layer renderInContext:context];
	
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

- (CGAffineTransform)collectionView:(UICollectionView *)collectionView transformForDraggingItemAtIndexPath:(NSIndexPath *)indexPath duration:(NSTimeInterval *)duration
{
	return CGAffineTransformMakeScale(1.05f, 1.05f);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString * item = self.dataArray[fromIndexPath.item];
    [self.dataArray removeObjectAtIndex:fromIndexPath.item];
    [self.dataArray insertObject:item atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

- (BOOL)collectionView:(UICollectionView *)collectionView canDeleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductClass *p = _dataArray[indexPath.item];
    [TheDatabaseManager delectWithProperty:@"productSerialNumber" andProperty:p.productSerialNumber withTableName:JIESUOTABELNAME];
    [self.collectionView setPresenting:NO animated:YES completion:nil];

    [self.dataArray removeObjectAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeleteItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark SearchCell

- (void)searchControllerWillBeginSearch:(SearchViewController *)controller
{
    if (!self.collectionView.presenting)
    {
        [self.collectionView setPresenting:YES animated:YES completion:nil];
    }
}

- (void)searchControllerWillEndSearch:(SearchViewController *)controller
{
    if (self.collectionView.presenting)
    {
        [TheDatabaseManager quaueupdataList:JIESUOTABELNAME conditions1:controller.searchBar.text andConditions2:controller.searchBar.text andConditions3:controller.searchBar.text andClass:[ProductClass class] withBlock:^(NSArray *arr) {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:arr];
            [self.collectionView reloadData];
            [self.collectionView setPresenting:NO animated:YES completion:nil];
        }];
    }
}

#pragma mark Backside

- (IBAction)flip:(id)sender
{
    PassCell *cell = (PassCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
	if (sender == cell.infoButton)
	{
		[cell flipTransitionWithOptions:UIViewAnimationOptionTransitionFlipFromLeft halfway:^(BOOL finished) {
			cell.infoButton.hidden = YES;
			cell.doneButton.hidden = NO;
		} completion:^(BOOL finished) {
            [cell.textFields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UITextField *t = obj;
                t.enabled = YES;
            }];
        }];
	}
	else
	{
        
       
		[cell flipTransitionWithOptions:UIViewAnimationOptionTransitionFlipFromRight halfway:^(BOOL finished) {
			cell.infoButton.hidden = NO;
			cell.doneButton.hidden = YES;
		} completion:^(BOOL finished) {
            [cell.textFields enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UITextField *t = obj;
                t.enabled = NO;
                [t resignFirstResponder];
            }];
            [self performSelector:@selector(sevaData) withObject:nil afterDelay:0];

        }];
	}
}

- (void)sevaData {
    PassCell *cell = (PassCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];

    static BOOL isOnly = NO;
    ProductClass *newP = [ProductClass new];
    newP.productSerialNumber = cell.productObject.productSerialNumber;
    for (UITextField *t in cell.textFields) {
        switch (t.tag) {
            case 101:{
                [t.text isEqualToString:cell.productObject.productAgent] ? ({}) : ({isOnly = YES;});
            }
                newP.productAgent = t.text;

                break;
            case 102:
                [t.text isEqualToString:cell.productObject.productPassword] ? ({}) : ({isOnly = YES;});
                newP.productPassword = t.text;
                break;
            case 103:
                [t.text isEqualToString:cell.productObject.productServiceName] ? ({}) : ({isOnly = YES;});
                newP.productServiceName = t.text;
                break;
            case 104:
                [t.text isEqualToString:cell.productObject.productDeliveryTime] ? ({}) : ({isOnly = YES;});
                newP.productDeliveryTime = t.text;
                break;
            case 105:
                [t.text isEqualToString:cell.productObject.dateOld] ? ({}) : ({isOnly = YES;});
                newP.dateOld = t.text;
                break;
            case 106:
                [t.text isEqualToString:cell.productObject.productDecryptionPersonnel] ? ({}) : ({isOnly = YES;});
                newP.productDecryptionPersonnel = t.text;
                break;
            case 107:
                [t.text isEqualToString:cell.productObject.productPhoneNumber] ? ({}) : ({isOnly = YES;});
                newP.productPhoneNumber = t.text;
                break;
            default:
                break;
        }
        
    }
    if (isOnly) {
        NSInteger idx = [_dataArray indexOfObject:cell.productObject];
        [_dataArray removeObjectAtIndex:idx];
        [_dataArray insertObject:newP atIndex:idx];
        [cell setData:newP];
        [TheDatabaseManager addObjectDataWithTableName:JIESUOTABELNAME installObject:newP oldObject:cell.productObject withAlerFlag:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

@end
