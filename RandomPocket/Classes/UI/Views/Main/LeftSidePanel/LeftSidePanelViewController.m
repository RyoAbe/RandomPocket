//
//  LeftSidePanelViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/02/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "LeftSidePanelViewController.h"
#import "RandomPocketUI.h"
#import "LeftSidePanelCell.h"
#import "AboutViewController.h"
#import "LicenseViewController.h"
#import "SettingsViewController.h"

typedef NS_ENUM(int, LeftSidePanelRowType) {
    LeftSidePanelRowTypePocketList = 0,
//    LeftSidePanelRowTypeSettings,
	LeftSidePanelRowTypeAbout,
//    LeftSidePanelRowTypeLicense,
    LeftSidePanelRowTypeLoginOrLogout,
    LeftSidePanelRowTypeTotal,
};

static NSString* const LeftSidePanelCellIdentifier = @"leftSidePanelCell";

@interface LeftSidePanelViewController ()
@property (nonatomic) UIActionSheet *actionSheet;
@end

@implementation LeftSidePanelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftSidePanelCell" bundle:nil] forCellReuseIdentifier:LeftSidePanelCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"DisconnectActionSheetTitle", @"LeftSidePanel", nil)];
    __weak LeftSidePanelViewController *wearkSelf = self;
    [self.actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Disconnect", @"LeftSidePanel", nil) handler:^{
        LogoutOperation *op = [[LogoutOperation alloc] init];
        [op setCompletionHandler:^(id result) {
            [NSManagedObjectContext deleteEntities];
            [wearkSelf.view.window makeToast:NSLocalizedStringFromTable(@"DisconnectComplete", @"LeftSidePanel", nil)];
            [wearkSelf.tableView reloadData];
        }];
        [op dispatch];
    }];
    [self.actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Common", nil) handler:nil];
    self.actionSheet.destructiveButtonIndex = 0;
    self.actionSheet.cancelButtonIndex = 1;
    [[PocketAPI sharedAPI] addObserver:self forKeyPath:@"isLoggedIn" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)logout
{
    [self.actionSheet showInView:self.view];
}

- (void)login
{
    [self presentLoginViewControllerWithSucceedBlock:^{ [self.tableView reloadData]; }
                                         cancelBlock:nil
                                          errorBlock:^{ [self.view makeToast:NSLocalizedStringFromTable(@"ConnectFaild", @"Common", nil)]; }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *centerPanel = [storyboard instantiateInitialViewController];
    if(indexPath.row == LeftSidePanelRowTypeAbout){
        centerPanel = [storyboard instantiateViewControllerWithIdentifier:@"About"];
    }else if(indexPath.row == LeftSidePanelRowTypeLoginOrLogout){
        if([PocketAPI sharedAPI].isLoggedIn){
            [self logout];
            return;
        }
        [self login];
        return;
    }

    self.sidePanelController.centerPanel = [self.sidePanelController createCenterPanel:centerPanel];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return LeftSidePanelRowTypeTotal;
}

- (LeftSidePanelCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftSidePanelCell *cell = [tableView dequeueReusableCellWithIdentifier:LeftSidePanelCellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == LeftSidePanelRowTypePocketList){
        cell.textLabel.text = NSLocalizedStringFromTable(@"Home", @"LeftSidePanel", nil);
    }else if(indexPath.row == LeftSidePanelRowTypeAbout){
        cell.textLabel.text = NSLocalizedStringFromTable(@"AbountApp", @"LeftSidePanel", nil);
    }else if(indexPath.row == LeftSidePanelRowTypeLoginOrLogout){
        NSString *key = [PocketAPI sharedAPI].isLoggedIn ? @"Disconnect" : @"Connect";
        cell.textLabel.text = NSLocalizedStringFromTable(key, @"LeftSidePanel", nil);
    }

    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == [PocketAPI sharedAPI] && [keyPath isEqualToString:@"isLoggedIn"]){
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
    [[PocketAPI sharedAPI] removeObserver:self forKeyPath:@"isLoggedIn"];
}

@end
