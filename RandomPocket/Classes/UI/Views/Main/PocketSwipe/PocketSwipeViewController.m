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
@property (nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) MRProgressOverlayView *progressView;
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
    self.navigationController.navigationBar.translucent = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"PocketDetailCell" bundle:nil] forCellWithReuseIdentifier:PocketDetailCellIdentifier];
    self.actionSheet = [self createActionSheet];
    self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width * self.selectedPocketIndex, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutForCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.pocketList.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.pocketList.delegate = nil;
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
    BlockActivity *activity = [BlockActivity activityWithType:@"Evernote" title:@"Evernote" image:[UIImage imageNamed:@"evernote_icon"] actionBlock:^{
        [UIUtil openInEvernoteWithURL:self.currentPocket.url title:self.currentPocket.title];
    }];
    
    NSArray *items = @[self.currentPocket.title, self.currentPocket.url];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:@[activity]];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)readedTapped:(id)sender
{
    [self.actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (IBAction)openInBrowseTapped:(id)sender
{
    NSURL *url = [NSURL URLWithString:self.currentPocket.url];
    [UIUtil openInSafariOrChrome:url];
}

#pragma mark - UIPocketListDelegate

- (void)pocketListWillChange:(UIPocketList *)pocketList {}

- (void)pocketList:(UIPocketList *)pocketList
     didChangeItem:(UIPocket *)uiPocket
      newIndexPath:(NSIndexPath *)newIndexPath
      oldIndexPath:(NSIndexPath *)oldIndexPath
        changeType:(UIPocketListChangeType)type
{
    switch (type) {
            case UIPocketListChangeType_Insert:
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
            case UIPocketListChangeType_Delete:
            [self.pocketList removeAtIndexPath:oldIndexPath];
            [self.collectionView deleteItemsAtIndexPaths:@[oldIndexPath]];
            break;
            case UIPocketListChangeType_Move:
            [self.collectionView moveItemAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
            break;
            case UIPocketListChangeType_Update:
            [self.collectionView reloadItemsAtIndexPaths:@[oldIndexPath]];
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
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
            case UIPocketListChangeType_Delete:
            [self.collectionView deleteItemsAtIndexPaths:@[newIndexPath]];
            break;
        default:
            break;
    }
}

- (void)pocketListDidChange:(UIPocketList *)pocketList {}

#pragma mark - Other

- (UIActionSheet*)createActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil];
    __block PocketSwipeViewController *weakSelf = self;
    [actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"ArchiveButtonTitle", @"PocketSwipeView", nil) handler:^{
        ActionToPocketOperation *op = [[ActionToPocketOperation alloc] initWithItemID:weakSelf.currentPocket.itemID actionType:ActionToPocketType_Archive];
        weakSelf.progressView = [MRProgressOverlayView showWithTitle:NSLocalizedStringFromTable(@"Archive", @"Common", nil)];
        [op setCompletionHandler:^(id result) {
            [weakSelf.progressView hide];
            if(weakSelf.pocketList.numberOfItems == 0) [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
        [op setErrorHandler:^(NSError *error) {
            [weakSelf.progressView hide];
            [weakSelf.collectionView.window makeToast:NSLocalizedStringFromTable(@"ErrorOccured", @"Common", nil)];
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
