//
//  PocketSwipeViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/28.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketSwipeViewController.h"

@interface PocketSwipeViewController ()
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
    self.collectionView.contentOffset = CGPointMake(self.view.frame.size.width * [self.pocketList indexForObject:self.selectedPocket], 0);
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

@end
