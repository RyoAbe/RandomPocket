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
    [self.refreshController addTarget:self action:@selector(reqestGetPocketList) forControlEvents:UIControlEventValueChanged];
    
    // DimmingView
    self.HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
	[[UIApplication sharedApplication].delegate.window addSubview:self.HUD];
	self.HUD.labelText = NSLocalizedStringFromTable(@"Loading", @"Common", nil);

    // リクエスト
    self.getPocketsOperation = [GetPocketsOperation new];
    [self reqestGetPocketList];

    // PocketList
    self.pocketList = [[UIPocketList alloc] init];
    self.pocketList.delegate = self;
}

- (void)reqestGetPocketList
{
    BOOL isShowDimminingView = [self shouldBeShowDimminingView];
    
    __weak PocketListViewController *weakSelf = self;
    [self.getPocketsOperation setCompletionHandler:^(id result) {
        if(isShowDimminingView) [weakSelf.HUD hide:YES];
        [weakSelf.refreshController endRefreshing];
    }];
    [self.getPocketsOperation setErrorHandler:^(NSError *error) {
        if(isShowDimminingView) [weakSelf.HUD hide:YES];
        [weakSelf.refreshController endRefreshing];
        [weakSelf.view makeToast:[NSString stringWithFormat:@"GetPocketsOperation error: %@", error]];
    }];

    if(isShowDimminingView) [self.HUD show:YES];
    [self.getPocketsOperation execute];
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

- (void)pocketList:(UIPocketList *)pocketList didChangeItem:(UIPocket *)uiPocket newIndexPath:(NSIndexPath *)newIndexPath oldIndexPath:(NSIndexPath *)oldIndexPath changeType:(UIPocketListChangeType)type
{
    [self.tableView reloadData];
}

- (void)pocketList:(UIPocketList *)pocketList
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
         indexPath:(NSIndexPath *)newIndexPath
        changeType:(UIPocketListChangeType)type
{}
- (void)pocketListDidChange:(UIPocketList *)pocketList {}
- (void)pocketListWillChange:(UIPocketList *)pocketList {}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.pocketList.numberOfSections;
}

- (PocketListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PocketListCell *cell = [tableView dequeueReusableCellWithIdentifier:PokcetListCellIdentifier forIndexPath:indexPath];
    cell.pocket = [self.pocketList objectAtIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pocketList numberOfItemsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:ToPocketSwipeSegue sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIPocket* pocket = [self.pocketList objectAtIndexPath:indexPath];
    return [PocketListCell cellHeight:pocket];
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
