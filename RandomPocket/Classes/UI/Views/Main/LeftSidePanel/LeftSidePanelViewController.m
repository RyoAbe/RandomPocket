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
    LeftSidePanelRowTypeSettings,
	LeftSidePanelRowTypeAbout,
    LeftSidePanelRowTypeLicense,
    LeftSidePanelRowTypeTotal,
};

static NSString* const LeftSidePanelCellIdentifier = @"leftSidePanelCell";

@interface LeftSidePanelViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *centerPanel = [storyboard instantiateInitialViewController];
    if(indexPath.row == LeftSidePanelRowTypeSettings){
        centerPanel = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    }else if(indexPath.row == LeftSidePanelRowTypeAbout){
        centerPanel = [storyboard instantiateViewControllerWithIdentifier:@"About"];
    }else if(indexPath.row == LeftSidePanelRowTypeLicense){
        centerPanel = [storyboard instantiateViewControllerWithIdentifier:@"License"];
    }
    self.sidePanelController.centerPanel = [JASidePanelController createCenterPanel:centerPanel];
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
        cell.textLabel.text = NSLocalizedStringFromTable(@"MyPocket", @"LeftSidePanel", nil);
    }else if(indexPath.row == LeftSidePanelRowTypeSettings){
        cell.textLabel.text = NSLocalizedStringFromTable(@"Settings", @"LeftSidePanel", nil);
    }else if(indexPath.row == LeftSidePanelRowTypeAbout){
        cell.textLabel.text = NSLocalizedStringFromTable(@"AbountApp", @"LeftSidePanel", nil);
    }else if(indexPath.row == LeftSidePanelRowTypeLicense){
        cell.textLabel.text = NSLocalizedStringFromTable(@"License", @"LeftSidePanel", nil);
    }

    return cell;
}

@end
