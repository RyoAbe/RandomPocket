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
@property (nonatomic) NSMutableDictionary *randomIndexPaths;
@property (nonatomic) UIPocketListMode displayMode;
@end

@implementation UIPocketList

+ (id)allocWithZone:(struct _NSZone *)zone
{
    id copySelf = [super allocWithZone:zone];
    if(copySelf){
        [copySelf initializeSettings];
    }
    return copySelf;
}

- (void)initializeSettings
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    [delegate addObserver:self forKeyPath:@"managedObjectContext" options:NSKeyValueObservingOptionNew context:nil];

    self.randomIndexPaths = [NSMutableDictionary dictionary];
}

#pragma mark - Fetched results controller

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
    if(self.displayMode == UIPocketListMode_DisplayRandom){
        indexPath = [self indexPathFromKey:[[self.randomIndexPaths allKeysForObject:indexPath] lastObject]];
    }
    
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

- (BOOL)isEmpty
{
    return self.numberOfItems == 0;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
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
    [self.fetchedResultsController.fetchedObjects bk_match:^BOOL(CPocket *cPocket) {
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
    CPocket *cPocket = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [[UIPocket alloc] initWithCPocket:cPocket];
}

#pragma mark - Random IndexPath

/**
 *  引数で受け取ったindexPathをキーとしてrandomIndexPathsの値を除去
 *
 *  @param removeIndexPathKey 削除対象のキーとなるindexPath
 */
- (void)removeAtIndexPath:(NSIndexPath*)removeIndexPathKey
{
    if(self.displayMode == UIPocketListMode_DisplayNormal){
        return;
    }
    NSString *removeKey = [self indexPathKey:removeIndexPathKey];
    NSIndexPath *removeIndexPathValue = self.randomIndexPaths[removeKey];
    [self.randomIndexPaths removeObjectForKey:removeKey];
    
    NSMutableDictionary *newIndexPaths = [NSMutableDictionary dictionary];
    NSUInteger loop = self.randomIndexPaths.count;
    for (NSInteger row = 0; row <= loop; row++) {
        if(row == removeIndexPathKey.row){
            continue;
        }
        NSIndexPath *indexPathKey = [NSIndexPath indexPathForRow:row inSection:removeIndexPathKey.section];
        NSString *newKey = [self indexPathKey:indexPathKey];
        NSIndexPath *newValue = self.randomIndexPaths[newKey];
        if(indexPathKey.row >= removeIndexPathKey.row){
            newKey = [self indexPathKey:indexPathKey.row - 1 section:removeIndexPathKey.section];
        }
        if(newValue.row >= removeIndexPathValue.row){
            newValue = [NSIndexPath indexPathForRow:newValue.row - 1 inSection:removeIndexPathValue.section];
        }
        newIndexPaths[newKey] = newValue;
    }
    self.randomIndexPaths = newIndexPaths;
}

/**
 *  ランダムなindexPathのdictionaryを作成
 */
- (void)genrateRandomIndexPathes
{
    self.randomIndexPaths = [NSMutableDictionary dictionary];
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.numberOfItems; i++) {
        indexPathArray[i] = [NSIndexPath indexPathForRow:i inSection:0];
    }
    for (NSInteger i = 0; i < self.numberOfItems; i++) {
        NSUInteger randomNumber = arc4random_uniform((uint32_t)indexPathArray.count);
        NSString *key = [self indexPathKey:i section:0];
        self.randomIndexPaths[key] = indexPathArray[randomNumber];
        [indexPathArray removeObjectAtIndex:randomNumber];
    }
}

/**
 *  生成済みのrandomIndexPathの中身を見ながら、ランダムなindexPathを生成
 *
 *  @param indexPath キーとなるindexPath
 *
 *  @return ランダムなindexPath
 */
- (NSIndexPath*)generateRandomIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger numberOfItemsInSection = [self numberOfItemsInSection:indexPath.section];
    NSString *indexPathKey = [self indexPathKey:indexPath];
    if(self.randomIndexPaths.count >= numberOfItemsInSection){
        NSIndexPath *retIndexPath = self.randomIndexPaths[indexPathKey];
        return retIndexPath;
    }
    
    if([self.randomIndexPaths objectForKey:indexPath]){
        return self.randomIndexPaths[indexPathKey];
    }

    NSIndexPath *retIndexPath = nil;
    while (YES) {
        NSUInteger randomRow = arc4random_uniform((uint32_t)numberOfItemsInSection);
        retIndexPath = [NSIndexPath indexPathForRow:randomRow inSection:indexPath.section];
        NSAssert(retIndexPath, @"should be not nil indexPath");
        if(![self isAddedIndexPath:retIndexPath]){
            self.randomIndexPaths[indexPathKey] = retIndexPath;
            break;
        }
    }
    return retIndexPath;
}

/**
 *  引数からランダムなindexPathの生成用のキーを生成
 *
 *  @param row     indexPathのrow
 *  @param section indexPathのsection
 *
 *  @return キー("[0,0]")を返す
 */
- (NSString*)indexPathKey:(NSUInteger)row section:(NSUInteger)section
{
    return [self indexPathKey:[NSIndexPath indexPathForRow:row inSection:section]];
}

/**
 *  引数のindexPathを使ってランダムなindexPathの生成用のキーを生成
 *
 *  @param indexPath キー生成用のindexPath
 *
 *  @return キー("[0,0]")を返す
 */
- (NSString*)indexPathKey:(NSIndexPath*)indexPath
{
   return [NSString stringWithFormat:@"[%ld,%ld]", (long)indexPath.section, (long)indexPath.row];
}

/**
 *  NSString型のキー（"[0,0]"）からNSIndexPathを生成
 *
 *  @param key 文字列のキー（"[0,0]"）
 *
 *  @return 文字列のキーから生成されたNSIndexPath
 */
- (NSIndexPath*)indexPathFromKey:(NSString*)key
{
    // 「[0, 0]」の両端のカッコを除去
    NSString *tmpKey = [key substringWithRange:NSMakeRange(1, key.length - 2)];
    NSArray *separatedArray = [tmpKey componentsSeparatedByString:@","];

    return [NSIndexPath indexPathForRow:[(NSString*)separatedArray[1] integerValue] inSection:[(NSString*)separatedArray[0] integerValue]];
}

- (BOOL)isAddedIndexPath:(NSIndexPath*)randomIndexPath
{
    return [self.randomIndexPaths.allValues containsObject:randomIndexPath];
}

#pragma mark -

/**
 *   ディスプレイモードを変更する
 *
 *  @param displayMode ディスプレイモード
 */
- (void)changeDisplayMode:(UIPocketListMode)displayMode
{
    _displayMode = displayMode;
    if([self isDisplayModeNormal]){
        return;
    }
    [self genrateRandomIndexPathes];
}

- (BOOL)isDisplayModeNormal
{
    return _displayMode == UIPocketListMode_DisplayNormal;
}

- (id)copyWithZone:(NSZone *)zone
{
    UIPocketList *pocketList = [[self class] allocWithZone:zone];
    pocketList.randomIndexPaths = self.randomIndexPaths;
    pocketList.displayMode = self.displayMode;
    return pocketList;
}

#pragma - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(object == delegate && [keyPath isEqualToString:@"managedObjectContext"]){
        _fetchedResultsController = nil;
        _managedObjectContext = [delegate managedObjectContext];
        _fetchedResultsController = [self fetchedResultsController];
    }
}

- (void)dealloc
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate removeObserver:self forKeyPath:@"managedObjectContext"];
}

@end
