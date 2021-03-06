//
//  PocketListViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/25.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketListViewController.h"

@interface PocketListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *randomButton;
@property (nonatomic) UIPocketList *pocketList;
@property (nonatomic) MRProgressOverlayView *progressView;
@property (nonatomic) UIRefreshControl *refreshController;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) NSIndexPath *swipedIndexPath;
@property (nonatomic) GetSimplePocketsOperation *getPocketsOperation;
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@property (nonatomic) LoginViewController *loginViewController;
@end

static NSString* const PokcetListCellIdentifier = @"pokcetListCell";
static NSString* const ToPocketSwipeSegue = @"toPocketSwipe";

@implementation PocketListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"PocketListCell" bundle:nil] forCellReuseIdentifier:PokcetListCellIdentifier];

    self.refreshController = [UIRefreshControl new];
    self.refreshController.layer.zPosition = -1;
    [self.tableView addSubview:self.refreshController];

    __weak PocketListViewController *weakSelf = self;
    [self.refreshController bk_addEventHandler:^(id sender) {
        [weakSelf reqestGetPockets:weakSelf.pocketList.isEmpty];
    } forControlEvents:UIControlEventValueChanged];
    
    self.tableView.alwaysBounceVertical = YES;

    // リクエスト
    self.getPocketsOperation = [GetSimplePocketsOperation new];

    // PocketList
    self.pocketList = [[UIPocketList alloc] init];

    // NJKScrollFullScreen
    self.scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    self.tableView.delegate = (id)self.scrollProxy;
    self.scrollProxy.delegate = self;

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationTitleLogo"]];
    
    if(self.pocketList.isEmpty){
        if(![PocketAPI sharedAPI].isLoggedIn){
            [self bk_performBlock:^(id sender){
                [self presentLoginViewControllerWithSucceedBlock:^{ [self reqestGetPockets:YES]; }
                                                     cancelBlock:nil
                                                      errorBlock:^{ [self.tableView.window makeToast:NSLocalizedStringFromTable(@"ErrorOccured", @"Common", nil)]; } ];
                
            } afterDelay:0.5f];
            return;
        }
        [self reqestGetPockets:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.pocketList.delegate = self;
}

- (void)reqestGetPockets:(BOOL)isShowDimminingView
{
    if(!self.pocketList.isDisplayModeNormal) [self changeSortMode:UIPocketListMode_DisplayNormal];
    
    __weak PocketListViewController *weakSelf = self;
    [self.getPocketsOperation setCompletionHandler:^(id result) {
        if(isShowDimminingView) [weakSelf.progressView hide];
        [weakSelf.refreshController endRefreshing];
    }];
    [self.getPocketsOperation setErrorHandler:^(NSError *error) {
        if(isShowDimminingView) [weakSelf.progressView hide];
        [weakSelf.refreshController endRefreshing];
        [weakSelf.tableView.window makeToast:NSLocalizedStringFromTable(@"ErrorOccured", @"Common", nil)];
    }];

    if(isShowDimminingView) self.progressView = [MRProgressOverlayView showWithTitle:NSLocalizedStringFromTable(@"Loading", @"Common", nil)];
    [self.getPocketsOperation dispatch];
}

#pragma mark - UIPocketListDelegate

- (void)pocketListWillChange:(UIPocketList *)pocketList
{
    [self.tableView beginUpdates];
}

- (void)pocketList:(UIPocketList *)pocketList
     didChangeItem:(UIPocket *)uiPocket
      newIndexPath:(NSIndexPath *)newIndexPath
      oldIndexPath:(NSIndexPath *)oldIndexPath
        changeType:(UIPocketListChangeType)type
{
    switch (type) {
        case UIPocketListChangeType_Insert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case UIPocketListChangeType_Delete:
            [self.pocketList removeAtIndexPath:oldIndexPath];
            [self.tableView deleteRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case UIPocketListChangeType_Move:
            [self.tableView moveRowAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
            break;
        case UIPocketListChangeType_Update:
            [self.tableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void)pocketList:(UIPocketList *)pocketList
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
         indexPath:(NSIndexPath *)newIndexPath
        changeType:(UIPocketListChangeType)type
{
    switch (type) {
        case UIPocketListChangeType_Insert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        case UIPocketListChangeType_Delete:
            [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        default:
            break;
    }
}

- (void)pocketListDidChange:(UIPocketList *)pocketList
{
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    [self showNavigationBar:NO];
    [self performSegueWithIdentifier:ToPocketSwipeSegue sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIPocket *uiPocket = [self.pocketList objectAtIndexPath:indexPath];
    NSString *title = uiPocket.title ? uiPocket.title : uiPocket.url;
    PocketListCell *cell = [tableView dequeueReusableCellWithIdentifier:PokcetListCellIdentifier];
    return [cell cellHeightWithTitle:title];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedStringFromTable(@"CellArchiveButtonTitle", @"PocketList", nil);
}

#pragma mark - UITableViewDataSource

- (PocketListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PocketListCell *cell = [tableView dequeueReusableCellWithIdentifier:PokcetListCellIdentifier forIndexPath:indexPath];
    cell.pocket = [self.pocketList objectAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pocketList numberOfItemsInSection:section];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.swipedIndexPath = indexPath;
    UIPocket *pocket = [self.pocketList objectAtIndexPath:indexPath];
    ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithItemID:pocket.itemID actionType:ActionToPocketType_Archive];
    self.progressView = [MRProgressOverlayView showWithTitle:NSLocalizedStringFromTable(@"Archive", @"Common", nil)];
    __weak PocketListViewController *weakSelf = self;
    [op setCompletionHandler:^(id result) {
        [weakSelf.progressView hide];
        [weakSelf.tableView.window makeToast:NSLocalizedStringFromTable(@"Archived", @"Common", nil)];
    }];
    [op setErrorHandler:^(NSError *error) {
        [weakSelf.progressView hide];
        [weakSelf.tableView.window makeToast:NSLocalizedStringFromTable(@"ErrorOccured", @"Common", nil)];
    }];
    [op dispatch];
}

#pragma mark - MSCMoreOptionTableViewCellDelegate

- (void)tableView:(UITableView *)tableView moreOptionButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIPocket *pocket = [self.pocketList objectAtIndexPath:indexPath];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:nil];
    __weak PocketListViewController *weakSelf = self;

    // impl add tag
//    [actionSheet addButtonWithTitle:@"Add Tag" handler:^{}];

    [actionSheet bk_addButtonWithTitle:NSLocalizedStringFromTable(@"FavoriteButtonTitle", @"PocketList", nil) handler:^{
        ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithItemID:pocket.itemID actionType:ActionToPocketType_Favorite];
        [op setCompletionHandler:^(id result) {
            [weakSelf.tableView.window makeToast:NSLocalizedStringFromTable(@"Favorite", @"Common", nil)];
        }];
        [op setErrorHandler:^(NSError *error) {
            [weakSelf.tableView.window makeToast:NSLocalizedStringFromTable(@"ErrorOccured", @"Common", nil)];
        }];
        [op dispatch];
    }];
    [actionSheet bk_addButtonWithTitle:NSLocalizedStringFromTable(@"DeleteButtonTitle", @"PocketList", nil) handler:^{
        ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithItemID:pocket.itemID actionType:ActionToPocketType_Delete];
        [op setCompletionHandler:^(id result) {
            [weakSelf.tableView.window makeToast:NSLocalizedStringFromTable(@"Deleted", @"Common", nil)];
        }];
        [op setErrorHandler:^(NSError *error) {
            [weakSelf.tableView.window makeToast:NSLocalizedStringFromTable(@"ErrorOccured", @"Common", nil)];
        }];
        [op dispatch];
    }];
    [actionSheet bk_addButtonWithTitle:NSLocalizedStringFromTable(@"ViewWebsiteButtonTitle", @"PocketList", nil) handler:^{
        UINavigationController *webViewController = [self webViewControllerWithURL:pocket.url];
        [self.navigationController presentViewController:webViewController animated:YES completion:nil];
    }];
    [actionSheet bk_addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Common", nil) handler:nil];

    actionSheet.destructiveButtonIndex = 1;
    actionSheet.cancelButtonIndex = 3;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (NSString *)tableView:(UITableView *)tableView titleForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedStringFromTable(@"CellMoreButtonTitle", @"PocketList", nil);
}

-(UIColor *)tableView:(UITableView *)tableView backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RPColor PocketListCellArchiveButtonColor];
}

- (UIColor *)tableView:(UITableView *)tableView backgroundColorForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RPColor PocketListCellMoreButtonColor];
}

#pragma mark - IBAction

- (IBAction)toRandomSortTapped:(UITabBarItem*)tabBarItem
{
    UIPocketListMode mode = 0;
    NSString *title = nil;
    switch (self.pocketList.displayMode) {
        case UIPocketListMode_DisplayNormal:
            mode = UIPocketListMode_DisplayRandom;
            title = NSLocalizedStringFromTable(@"ToRandomSort", @"PocketList", nil);
            break;
        case UIPocketListMode_DisplayRandom:
            mode = UIPocketListMode_DisplayNormal;
            title = NSLocalizedStringFromTable(@"ToNormalSort", @"PocketList", nil);
            break;
    }
    self.progressView = [MRProgressOverlayView showWithTitle:title mode:MRProgressOverlayViewModeIndeterminateSmall];
    [self changeSortMode:mode completion:^{
        [self.progressView hide];
    }];
}

- (void)changeRightBarButtonItem
{
    switch (self.pocketList.displayMode) {
        case UIPocketListMode_DisplayNormal:
            self.randomButton.image = [UIImage imageNamed:@"shuffle_icon"];
            break;
        case UIPocketListMode_DisplayRandom:
            self.randomButton.image = [UIImage imageNamed:@"revert_icon"];
            break;
    }
}

- (void)changeSortMode:(UIPocketListMode)mode
{
    [self changeSortMode:mode completion:nil];
}

- (void)changeSortMode:(UIPocketListMode)mode completion:(void (^)())completion
{
    [self bk_performBlock:^(id sender) {
        [self.pocketList changeDisplayMode:mode];
        [self changeRightBarButtonItem];
        [self.tableView reloadData];
        if(completion) completion();
        if(self.pocketList.numberOfItems > 0){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    } afterDelay:0.05];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self.tableView.window makeToast:@"unimplemented"];
}

#pragma mark - NJKScrollFullscreenDelegate

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES]; // move to revese direction
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
    [self hideToolbar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:ToPocketSwipeSegue]){
        PocketSwipeViewController *vc = segue.destinationViewController;
        vc.selectedPocketIndex = self.selectedIndexPath.row;
        vc.pocketList = [self.pocketList copy];
    }
}

@end
