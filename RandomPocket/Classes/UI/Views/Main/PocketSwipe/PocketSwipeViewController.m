//
//  PocketSwipeViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/28.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketSwipeViewController.h"
#import "RandomPocketUI.h"

@interface PocketSwipeViewController ()
- (IBAction)actionButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic) MBProgressHUD *HUD;
@property (nonatomic) UIActionSheet *actionSheet;
@end

static NSString* const PocketDetailCellIdentifier = @"PocketDetailCell";

@implementation PocketSwipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PocketDetailCell" bundle:nil] forCellWithReuseIdentifier:PocketDetailCellIdentifier];
    self.HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
	[[UIApplication sharedApplication].delegate.window addSubview:self.HUD];
	self.HUD.labelText = NSLocalizedStringFromTable(@"Archive", @"Common", nil);
    self.actionSheet = [self createActionSheet];
    self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width * self.selectedPocketIndex, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutForCollectionView];
}

- (void)layoutForCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGSize size = self.view.frame.size;
    size.height = size.height - self.navigationController.navigationBar.frame.size.height;
    flowLayout.itemSize = size;
    self.collectionView.collectionViewLayout = flowLayout;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.pocketList.numberOfSections;
}

- (PocketDetailCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PocketDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PocketDetailCellIdentifier forIndexPath:indexPath];
    cell.pocket = [self.pocketList objectAtIndexPath:indexPath];
    cell.vc = self;
    self.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"NavigationTitleFormat", @"PocketDetail", nil), indexPath.row + 1, self.pocketList.numberOfItems];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.pocketList numberOfItemsInSection:section];
}

#pragma mark - IBAction

- (IBAction)actionButtonTapped:(id)sender
{
    NSArray *items = @[self.currentPocket.title, self.currentPocket.url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)readedTapped:(id)sender
{
    [self.actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (IBAction)openInSafariTapped:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.currentPocket.url]];
}

#pragma mark - Other

- (UIActionSheet*)createActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil];
    __block PocketSwipeViewController *weakSelf = self;
    [actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"ArchiveButtonTitle", @"PocketSwipeView", nil) handler:^{
        ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithPocketID:weakSelf.currentPocket.objectID actionType:ActionToPocketType_Archive];
        [op setCompletionHandler:^(id result) {
            if(weakSelf.pocketList.numberOfItems == 0){
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
            [weakSelf.pocketList removeAtIndexPath:weakSelf.currentIndexPath];
            [weakSelf.collectionView reloadData];
        }];
        [op setErrorHandler:^(NSError *error) {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"archive error: %@", error]];
        }];
        [op dispatch];
    }];
    [actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Common", nil) handler:nil];
    actionSheet.destructiveButtonIndex = 0;
    actionSheet.cancelButtonIndex = 1;
    
    return actionSheet;
}

- (UIPocket*)currentPocket
{
    return self.currentCell.pocket;
}

- (PocketDetailCell*)currentCell
{
    return (PocketDetailCell*) self.collectionView.visibleCells[0];
}

- (NSIndexPath*)currentIndexPath
{
   return [self.collectionView indexPathForCell:self.currentCell];
}

@end
