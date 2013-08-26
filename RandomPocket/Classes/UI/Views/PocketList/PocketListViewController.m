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
@end

static NSString* const PokcetListCellIdentifier = @"PokcetListCell";

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
    
    // RefreshController
    self.refreshController = [UIRefreshControl new];
    [self.tableView addSubview:self.refreshController];
    [self.refreshController addTarget:self action:@selector(reqestPocketList) forControlEvents:UIControlEventValueChanged];
    
    // DimmingView
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.view addSubview:self.HUD];
	self.HUD.labelText = NSLocalizedStringFromTable(@"Loading", @"Common", nil);

    // リクエスト
    [self reqestPocketList];
}

- (void)reqestPocketList
{
    [self.HUD show:YES];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PokcetListCellIdentifier];
    self.pocketList = [[UIPocketList alloc] initWithSuccessBlock:^{
        [self.HUD hide:YES];
        [self.refreshController endRefreshing];
        [self.tableView reloadData];
    } errorBlock:^{
        [self.HUD hide:YES];
        [self.refreshController endRefreshing];
        [self.view makeToast:NSLocalizedStringFromTable(@"FaildRequestPocketList", @"PocketList", nil)];
    }];
    
    [self.pocketList request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.pocketList.numberOfSections;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PokcetListCellIdentifier forIndexPath:indexPath];
    UIPocket *pocket = [self.pocketList objectAtIndexPath:indexPath];
    cell.textLabel.text = pocket.url;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.pocketList numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIPocket *pocket = [self.pocketList objectAtIndexPath:indexPath];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pocket.url]];
}

@end
