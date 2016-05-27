#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (UIButton *)getSearchBarCancelButton{
    
    UIButton* btn=nil;
    
    for(UIView* v in self.searchBar.subviews.firstObject.subviews) {
        
        if ([v isKindOfClass:UIButton.class]) {
            
            btn=(UIButton*)v;
            
            break;
            
        }
    }
    
    return btn;
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    UIButton *button = [self getSearchBarCancelButton];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    id<SearchViewControllerDelegate> delegate = self.delegate;
    if (delegate)
    {
        [delegate searchControllerWillBeginSearch:self];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    id<SearchViewControllerDelegate> delegate = self.delegate;
    if (delegate)
    {
        [delegate searchControllerWillEndSearch:self];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    id<SearchViewControllerDelegate> delegate = self.delegate;
    if (delegate)
    {
        [delegate searchControllerWillEndSearch:self];
    }
}

@end
