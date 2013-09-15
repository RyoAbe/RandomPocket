//
//  PocketSwipeViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/28.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketSwipeViewController.h"

@interface PocketSwipeViewController ()
- (IBAction)actionButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
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
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
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
    self.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"NavigationTitleFormat", @"PocketDetail", nil), indexPath.row + 1, self.pocketList.numberOfItems];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.pocketList numberOfItemsInSection:section];
}

- (IBAction)actionButtonTapped:(id)sender
{
    NSArray *items = @[self.currentPocket.title, self.currentPocket.url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)readedTapped:(id)sender
{
    RequestActionToPocketOperation *op = [[RequestActionToPocketOperation alloc] initWithPocketID:self.currentPocket.objectID actionType:RequestActionToPocketType_Archive];
    __weak PocketSwipeViewController *weakSelf = self;
    [op setCompletionHandler:^{
        [weakSelf.view makeToast:@"Arcived"];
    }];
    [op setErrorHandler:^(NSError *error) {
        [weakSelf.view makeToast:[NSString stringWithFormat:@"GetPocketsOperation error: %@", error]];
    }];
    [op request];
}

- (UIPocket*)currentPocket
{
    return ((PocketDetailCell*) self.collectionView.visibleCells[0]).pocket;
}

@end
