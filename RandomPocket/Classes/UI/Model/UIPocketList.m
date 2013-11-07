//
//  UIPocketList.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIPocketList.h"
#import "RandomPocketUI.h"

@interface UIPocketList()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableDictionary *indexPaths;
@end

@implementation UIPocketList

#pragma mark - Fetched results controller

- (id)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        self.indexPaths = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CPocket" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.fetchBatchSize = 20;

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortID" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"status == %d", PocketStatus_Unread];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        NSAssert(NO, error.userInfo.description);
	}
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.delegate pocketListWillChange:self];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.delegate pocketListDidChange:self];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    [self.delegate pocketList:self didChangeSection:sectionInfo indexPath:[NSIndexPath indexPathWithIndex:sectionIndex] changeType:type];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UIPocket *uiPocket = [[UIPocket alloc] initWithCPocket:(CPocket*)anObject];
    [self.delegate pocketList:self didChangeItem:uiPocket newIndexPath:newIndexPath oldIndexPath:indexPath changeType:type];
}

#pragma mark -

- (NSInteger)numberOfSections
{
    return self.fetchedResultsController.sections.count;
}

- (NSUInteger)numberOfItems
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (NSIndexPath*)indexPathForObject:(UIPocket*)uiPocket
{
    CPocket* cPocket = [self.fetchedResultsController.managedObjectContext entityWithID:uiPocket.objectID];
    return [self.fetchedResultsController indexPathForObject:cPocket];
}

- (NSInteger)indexForObject:(UIPocket*)uiPocket
{
    __block NSUInteger i = 0;
    [self.fetchedResultsController.fetchedObjects match:^BOOL(CPocket *cPocket) {
        return [cPocket.objectID isEqual:uiPocket.objectID] ? YES : i++; NO;
    }];
    return i;
}

- (UIPocket*)objectAtIndex:(NSUInteger)index
{
    CPocket *cPocket = self.fetchedResultsController.fetchedObjects[index];
    return [[UIPocket alloc] initWithCPocket:cPocket];
}

- (UIPocket*)objectAtIndexPath:(NSIndexPath*)indexPath
{
    switch (self.displayMode) {
        case UIPocketListMode_DisplayNormal:
            break;
        case UIPocketListMode_DisplayRandom:
            indexPath = [self generateRandomIndexPath:indexPath];
            break;
    }
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)setDisplayMode:(UIPocketListMode)displayMode
{
    _displayMode = displayMode;
    self.indexPaths = [NSMutableDictionary dictionary];
}

- (NSIndexPath*)generateRandomIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger numberOfItemsInSection = [self numberOfItemsInSection:indexPath.section];
    NSString *indexPathKey = [self indexPathKey:indexPath];
    if(self.indexPaths.count == numberOfItemsInSection){
        NSIndexPath *retIndexPath = self.indexPaths[indexPathKey];
        return retIndexPath;
    }
    
    if([self.indexPaths objectForKey:indexPath]){
        return self.indexPaths[indexPathKey];
    }

    NSIndexPath *retIndexPath = nil;
    while (YES) {
        NSUInteger randomRow = arc4random_uniform(numberOfItemsInSection);
        retIndexPath = [NSIndexPath indexPathForRow:randomRow inSection:indexPath.section];
        NSAssert(retIndexPath, @"should be not nil indexPath");
        if(![self isAddedIndexPath:retIndexPath]){
            self.indexPaths[indexPathKey] = retIndexPath;
            break;
        }
    }
    return retIndexPath;
}

- (NSString*)indexPathKey:(NSIndexPath*)indexPath
{
   return [NSString stringWithFormat:@"[%d,%d]", indexPath.section, indexPath.row];
}

- (BOOL)isAddedIndexPath:(NSIndexPath*)randomIndexPath
{
    return [self.indexPaths.allValues containsObject:randomIndexPath];
}

@end
