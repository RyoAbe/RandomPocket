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
@property (nonatomic) UIPocketList *pocketList;
@property (nonatomic) MBProgressHUD *HUD;
@property (nonatomic) UIRefreshControl *refreshController;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) GetPocketsOperation *getPocketsOperation;
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
    [self.tableView addSubview:self.refreshController];
    [self.refreshController addTarget:self action:@selector(reqestGetPockets) forControlEvents:UIControlEventValueChanged];
    
    // DimmingView
    self.HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
	[[UIApplication sharedApplication].delegate.window addSubview:self.HUD];
	self.HUD.labelText = NSLocalizedStringFromTable(@"Loading", @"Common", nil);

    // リクエスト
    self.getPocketsOperation = [GetPocketsOperation new];
    [self reqestGetPockets];

    // PocketList
    self.pocketList = [[UIPocketList alloc] init];
    self.pocketList.delegate = self;
}

- (void)reqestGetPockets
{
    BOOL isShowDimminingView = [self shouldBeShowDimminingView];
    
    __weak PocketListViewController *weakSelf = self;
    [self.getPocketsOperation setCompletionHandler:^(id result) {
        if(isShowDimminingView) [weakSelf.HUD hide:YES];
        [weakSelf.refreshController endRefreshing];
        [weakSelf.tableView reloadData];
    }];
    [self.getPocketsOperation setErrorHandler:^(NSError *error) {
        if(isShowDimminingView) [weakSelf.HUD hide:YES];
        [weakSelf.refreshController endRefreshing];
        [weakSelf.view makeToast:[NSString stringWithFormat:@"GetPocketsOperation error: %@", error]];
    }];

    if(isShowDimminingView) [self.HUD show:YES];
    [self.getPocketsOperation dispatch];
}

- (BOOL)shouldBeShowDimminingView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults boolForKey:@"NotFirstLaunch"]){
        return NO;
    }

    [defaults setBool:YES forKey:@"NotFirstLaunch"];
    [defaults synchronize];
    return YES;
}

#pragma mark - UIPocketListDelegate

- (void)pocketList:(UIPocketList *)pocketList didChangeItem:(UIPocket *)uiPocket newIndexPath:(NSIndexPath *)newIndexPath oldIndexPath:(NSIndexPath *)oldIndexPath changeType:(UIPocketListChangeType)type {}
- (void)pocketList:(UIPocketList *)pocketList didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo indexPath:(NSIndexPath *)newIndexPath changeType:(UIPocketListChangeType)type {}
- (void)pocketListDidChange:(UIPocketList *)pocketList{}
- (void)pocketListWillChange:(UIPocketList *)pocketList{}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:ToPocketSwipeSegue sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PocketListCell *cell = [tableView dequeueReusableCellWithIdentifier:PokcetListCellIdentifier];
    return [cell cellHeight:[self.pocketList objectAtIndexPath:indexPath]];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Archive";
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
    UIPocket *pocket = [self.pocketList objectAtIndexPath:indexPath];
    ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithPocketID:pocket.objectID actionType:ActionToPocketType_Archive];
    __weak PocketListViewController *weakSelf = self;
    [op setCompletionHandler:^(id result) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
    [op setErrorHandler:^(NSError *error) {
        [weakSelf.view makeToast:[NSString stringWithFormat:@"archive error: %@", error]];
    }];
    [op dispatch];
}

#pragma mark - MSCMoreOptionTableViewCellDelegate

- (void)tableView:(UITableView *)tableView moreOptionButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIPocket *pocket = [self.pocketList objectAtIndexPath:indexPath];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil];
    __weak PocketListViewController *weakSelf = self;

#warning impl add tag
//    [actionSheet addButtonWithTitle:@"Add Tag" handler:^{}];

    [actionSheet addButtonWithTitle:@"Favorite" handler:^{
        ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithPocketID:pocket.objectID actionType:ActionToPocketType_Favorite];
        [op setCompletionHandler:^(id result) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"Favorite"]];
        }];
        [op setErrorHandler:^(NSError *error) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"add to favorite error: %@", error]];
        }];
        [op dispatch];
    }];
    [actionSheet addButtonWithTitle:@"Delete" handler:^{
        ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithPocketID:pocket.objectID actionType:ActionToPocketType_Delete];
        [op setErrorHandler:^(NSError *error) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"delete error: %@", error]];
        }];
        [op setCompletionHandler:^(id result) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
        [op dispatch];
    }];
    [actionSheet addButtonWithTitle:@"Open " handler:^{
        UINavigationController *webViewController = [self webViewControllerWithURL:pocket.url];
        [self.navigationController presentViewController:webViewController animated:YES completion:nil];
    }];
    [actionSheet addButtonWithTitle:@"Cancel" handler:nil];

    actionSheet.destructiveButtonIndex = 2;
    actionSheet.cancelButtonIndex = 4;
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (NSString *)tableView:(UITableView *)tableView titleForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"More";
}

-(UIColor *)tableView:(UITableView *)tableView backgroundColorForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f];
}

#pragma mark - IBAction

- (IBAction)toRandomSortTapped:(UITabBarItem*)tabBarItem
{
    NSString *title = nil;
    switch (self.pocketList.displayMode) {
        case UIPocketListMode_DisplayNormal:
            title = NSLocalizedStringFromTable(@"ToNormalSort", @"PocketList", nil);
            self.pocketList.displayMode = UIPocketListMode_DisplayRandom;
            break;
        case UIPocketListMode_DisplayRandom:
            title = NSLocalizedStringFromTable(@"ToRandomSort", @"PocketList", nil);
            self.pocketList.displayMode = UIPocketListMode_DisplayNormal;
            break;
        default:
            break;
    }
    [tabBarItem setTitle:title];
    [self.tableView reloadData];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self.view makeToast:@"unimplemented"];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:ToPocketSwipeSegue]){
        PocketSwipeViewController *vc = segue.destinationViewController;
        vc.selectedPocketIndex = self.selectedIndexPath.row;
        vc.pocketList = self.pocketList;
    }
}

@end
