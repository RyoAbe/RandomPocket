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
    [self collectionViewLayout];
}

- (void)collectionViewLayout
{
    self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width * self.selectedPocketIndex, 0);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGSize size = self.view.frame.size;
    size.height = size.height - self.navigationController.navigationBar.frame.size.height;
    flowLayout.itemSize = size;
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
    PocketDetailCell *cell = self.collectionView.visibleCells[0];
    NSArray *items = @[cell.pocket.title, cell.pocket.url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}
@end
