//
//  UIPocketList.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomPocketCore.h"

@class UIPocketList;
@class UIPocket;

typedef enum UIPocketListChangeType_ {
    UIPocketListChangeType_Insert = 1,
    UIPocketListChangeType_Delete = 2,
    UIPocketListChangeType_Move = 3,
    UIPocketListChangeType_Update = 4,
} UIPocketListChangeType;

typedef NS_ENUM(NSUInteger, UIPocketListMode) {
    UIPocketListMode_DisplayNormal = 0,
    UIPocketListMode_DisplayRandom,
};

@protocol UIPocketListDelegate <NSObject>
-(void)pocketListWillChange:(UIPocketList*)pocketList;
-(void)pocketListDidChange:(UIPocketList*)pocketList;

-(void)pocketList:(UIPocketList*)pocketList
 didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
        indexPath:(NSIndexPath*)newIndexPath
       changeType:(UIPocketListChangeType)type;

-(void)pocketList:(UIPocketList*)pocketList
   didChangeItem:(UIPocket*)uiPocket
    newIndexPath:(NSIndexPath*)newIndexPath
    oldIndexPath:(NSIndexPath*)oldIndexPath
      changeType:(UIPocketListChangeType)type;
@end


@interface UIPocketList : NSObject<NSFetchedResultsControllerDelegate>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSUInteger)numberOfItems;
- (NSIndexPath*)indexPathForObject:(UIPocket*)uiPocket;
- (NSInteger)indexForObject:(UIPocket*)uiPocket;
- (UIPocket*)objectAtIndex:(NSUInteger)index;
- (UIPocket*)objectAtIndexPath:(NSIndexPath*)indexPath;
- (void)removeAtIndexPath:(NSIndexPath*)indexPathKey;
- (void)addAtIndexPath:(NSIndexPath*)indexPath forIndexPathKey:(NSIndexPath*)indexPathKey;
@property (nonatomic) NSMutableArray *response;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) id<UIPocketListDelegate> delegate;
@property (nonatomic) UIPocketListMode displayMode;

@end
