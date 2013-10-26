//
//  UIPocketListSpec.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/10/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "RandomPocketCore.h"
#import "RandomPocketUI.h"

@interface UIPocketList()
@property (nonatomic) NSMutableDictionary *indexPaths;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
- (NSIndexPath*)generateRandomIndexPath:(NSIndexPath*)indexPath;
- (BOOL)isAddedIndexPath:(NSIndexPath*)randomIndexPath;
@end

SPEC_BEGIN(UIPocketListSpec)

describe(@"UIPocketList", ^{
    
    __block UIPocketList *_pocketList = [[UIPocketList alloc] init];
    
    context(@"init", ^{
        it(@"コンストラクタ", ^{
            [[_pocketList should] beNonNil];
            [[_pocketList.managedObjectContext should] beNonNil];
            [[_pocketList.indexPaths should] beNonNil];
        });
    });

    context(@"generateRandomIndexPath", ^{
        
        __block id fetchedResultsSectionInfo = [OCMockObject mockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        __block id fetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        [[[fetchedResultsController stub] andReturn:@[fetchedResultsSectionInfo]] sections];
        
        it(@"indexPathsに追加されたものと生成されたrandomIndexPathが同一であること", ^{
            NSUInteger numberOfObjects = 1;
            [[[fetchedResultsSectionInfo stub] andReturnValue:OCMOCK_VALUE(numberOfObjects)] numberOfObjects];
            _pocketList.fetchedResultsController = fetchedResultsController;
            _pocketList.indexPaths = [NSMutableDictionary new];

            NSIndexPath *indexPathKey = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *randomIndexPath = [_pocketList generateRandomIndexPath:indexPathKey];
            [[[_pocketList.indexPaths should] have:1] items];
            [[_pocketList.indexPaths[indexPathKey] should] equal:randomIndexPath];
        });

        it(@"10個indexPathsに追加して、それらが1つしか入っていないこと", ^{
            NSUInteger numberOfObjects = 5;
            [[[fetchedResultsSectionInfo stub] andReturnValue:OCMOCK_VALUE(numberOfObjects)] numberOfObjects];
            _pocketList.fetchedResultsController = fetchedResultsController;
            _pocketList.indexPaths = [NSMutableDictionary new];
            
            NSIndexPath *randomIndexPath1 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            NSIndexPath *randomIndexPath2 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            NSIndexPath *randomIndexPath3 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            NSIndexPath *randomIndexPath4 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            NSIndexPath *randomIndexPath5 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            NSIndexPath *randomIndexPath6 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            NSIndexPath *randomIndexPath7 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
            NSIndexPath *randomIndexPath8 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
            NSIndexPath *randomIndexPath9 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
            NSIndexPath *randomIndexPath10 = [_pocketList generateRandomIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];

            NSDictionary *mathedIndesPathes1 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath1.section == addedRandomIndexPath.section && randomIndexPath1.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes2 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath2.section == addedRandomIndexPath.section && randomIndexPath2.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes3 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath3.section == addedRandomIndexPath.section && randomIndexPath3.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes4 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath4.section == addedRandomIndexPath.section && randomIndexPath4.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes5 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath5.section == addedRandomIndexPath.section && randomIndexPath5.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes6 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath6.section == addedRandomIndexPath.section && randomIndexPath6.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes7 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath7.section == addedRandomIndexPath.section && randomIndexPath7.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes8 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath8.section == addedRandomIndexPath.section && randomIndexPath8.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes9 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath9.section == addedRandomIndexPath.section && randomIndexPath9.row == addedRandomIndexPath.row);
            }];
            NSDictionary *mathedIndesPathes10 = [_pocketList.indexPaths select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                return (randomIndexPath10.section == addedRandomIndexPath.section && randomIndexPath10.row == addedRandomIndexPath.row);
            }];
            
            [[theValue([mathedIndesPathes1 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes2 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes3 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes4 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes5 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes6 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes7 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes8 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes9 count]) should] equal:theValue(1)];
            [[theValue([mathedIndesPathes10 count]) should] equal:theValue(1)];
        });
        
    });
    
    context(@"isAddedIndexPath", ^{
        it(@"存在していればfalseを返す", ^{
            _pocketList.indexPaths[[NSIndexPath indexPathForRow:0 inSection:0]] = [NSIndexPath indexPathForRow:0 inSection:0];
            _pocketList.indexPaths[[NSIndexPath indexPathForRow:0 inSection:1]] = [NSIndexPath indexPathForRow:0 inSection:1];
            
            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]) should] beFalse];
            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]]) should] beFalse];
        });

        it(@"既に存在していればtrueを返す", ^{
            _pocketList.indexPaths[[NSIndexPath indexPathForRow:0 inSection:0]] = [NSIndexPath indexPathForRow:0 inSection:0];
            _pocketList.indexPaths[[NSIndexPath indexPathForRow:0 inSection:1]] = [NSIndexPath indexPathForRow:0 inSection:1];

            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) should] beTrue];
            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]) should] beTrue];
        });

        it(@"混在しているパターン", ^{
            _pocketList.indexPaths[[NSIndexPath indexPathForRow:0 inSection:0]] = [NSIndexPath indexPathForRow:0 inSection:0];
            _pocketList.indexPaths[[NSIndexPath indexPathForRow:0 inSection:1]] = [NSIndexPath indexPathForRow:0 inSection:2];
            _pocketList.indexPaths[[NSIndexPath indexPathForRow:0 inSection:2]] = [NSIndexPath indexPathForRow:0 inSection:4];

            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) should] beTrue];
            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]) should] beFalse];
            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]) should] beTrue];
            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]]) should] beFalse];
            [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]]) should] beTrue];
        });
    });
});

SPEC_END
