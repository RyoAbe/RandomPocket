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
@property (nonatomic) NSMutableDictionary *randomIndexPaths;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
- (NSIndexPath*)generateRandomIndexPath:(NSIndexPath*)indexPath;
- (BOOL)isAddedIndexPath:(NSIndexPath*)randomIndexPath;
- (NSString*)indexPathKey:(NSIndexPath*)indexPath;
@end

SPEC_BEGIN(UIPocketListSpec)

describe(@"UIPocketList", ^{
    
    __block UIPocketList *_pocketList;
    beforeEach(^{
        _pocketList = [[UIPocketList alloc] init];
    });
    context(@"init", ^{
        it(@"コンストラクタ", ^{
            [[_pocketList should] beNonNil];
            [[_pocketList.managedObjectContext should] beNonNil];
            [[_pocketList.randomIndexPaths should] beNonNil];
        });
    });

    context(@"generateRandomIndexPath", ^{
        __block id fetchedResultsSectionInfo = [OCMockObject mockForProtocol:@protocol(NSFetchedResultsSectionInfo)];
        __block id fetchedResultsController = [OCMockObject mockForClass:[NSFetchedResultsController class]];
        beforeEach(^{
            [[[fetchedResultsController stub] andReturn:@[fetchedResultsSectionInfo]] sections];
        });
        context(@"RandomIndexPathの生成", ^{
            __block NSIndexPath *_indexPathKey;
            __block NSIndexPath *_randomIndexPath;
            beforeEach(^{
                NSUInteger numberOfObjects = 1;
                [[[fetchedResultsSectionInfo stub] andReturnValue:OCMOCK_VALUE(numberOfObjects)] numberOfObjects];
                _pocketList.fetchedResultsController = fetchedResultsController;
                _pocketList.randomIndexPaths = [NSMutableDictionary new];
                _indexPathKey = [NSIndexPath indexPathForRow:0 inSection:0];
                _randomIndexPath = [_pocketList generateRandomIndexPath:_indexPathKey];
            });
            it(@"indexPathsに追加されたものと生成されたrandomIndexPathが同一であること", ^{
                [[[_pocketList.randomIndexPaths should] have:1] items];
                [[_pocketList.randomIndexPaths[[_pocketList indexPathKey:_indexPathKey]] should] equal:_randomIndexPath];
            });
        });
        context(@"生成したRandomIndexPathをindexPathsに追加", ^{
            __block NSDictionary *_mathedIndexPathes1;
            __block NSDictionary *_mathedIndexPathes2;
            __block NSDictionary *_mathedIndexPathes3;
            __block NSDictionary *_mathedIndexPathes4;
            __block NSDictionary *_mathedIndexPathes5;
            __block NSDictionary *_mathedIndexPathes6;
            __block NSDictionary *_mathedIndexPathes7;
            __block NSDictionary *_mathedIndexPathes8;
            __block NSDictionary *_mathedIndexPathes9;
            __block NSDictionary *_mathedIndexPathes10;
            beforeEach(^{
                NSUInteger numberOfObjects = 5;
                [[[fetchedResultsSectionInfo stub] andReturnValue:OCMOCK_VALUE(numberOfObjects)] numberOfObjects];
                _pocketList.fetchedResultsController = fetchedResultsController;
                _pocketList.randomIndexPaths = [NSMutableDictionary new];
                
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
                
                _mathedIndexPathes1 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath1.section == addedRandomIndexPath.section && randomIndexPath1.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes2 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath2.section == addedRandomIndexPath.section && randomIndexPath2.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes3 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath3.section == addedRandomIndexPath.section && randomIndexPath3.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes4 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath4.section == addedRandomIndexPath.section && randomIndexPath4.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes5 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath5.section == addedRandomIndexPath.section && randomIndexPath5.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes6 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath6.section == addedRandomIndexPath.section && randomIndexPath6.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes7 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath7.section == addedRandomIndexPath.section && randomIndexPath7.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes8 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath8.section == addedRandomIndexPath.section && randomIndexPath8.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes9 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath9.section == addedRandomIndexPath.section && randomIndexPath9.row == addedRandomIndexPath.row);
                }];
                _mathedIndexPathes10 = [_pocketList.randomIndexPaths bk_select:^BOOL(NSIndexPath *normalIndexPath, NSIndexPath *addedRandomIndexPath) {
                    return (randomIndexPath10.section == addedRandomIndexPath.section && randomIndexPath10.row == addedRandomIndexPath.row);
                }];
            });
            it(@"10個indexPathsに追加して、それらが1つしか入っていないこと", ^{
                [[theValue([_mathedIndexPathes1 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes2 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes3 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes4 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes5 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes6 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes7 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes8 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes9 count]) should] equal:theValue(1)];
                [[theValue([_mathedIndexPathes10 count]) should] equal:theValue(1)];
            });
        });
    });
    context(@"isAddedIndexPath", ^{
        context(@"falseのパターン", ^{
            beforeEach(^{
                _pocketList.randomIndexPaths[[NSIndexPath indexPathForRow:0 inSection:0]] = [NSIndexPath indexPathForRow:0 inSection:0];
                _pocketList.randomIndexPaths[[NSIndexPath indexPathForRow:0 inSection:1]] = [NSIndexPath indexPathForRow:0 inSection:1];
            });
            it(@"存在していればfalseを返す", ^{
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]) should] beFalse];
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]]) should] beFalse];
            });
        });
        context(@"trueのパターン", ^{
            beforeEach(^{
                _pocketList.randomIndexPaths[[NSIndexPath indexPathForRow:0 inSection:0]] = [NSIndexPath indexPathForRow:0 inSection:0];
                _pocketList.randomIndexPaths[[NSIndexPath indexPathForRow:0 inSection:1]] = [NSIndexPath indexPathForRow:0 inSection:1];
            });
            it(@"既に存在していればtrueを返す", ^{
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) should] beTrue];
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]) should] beTrue];
            });
        });
        context(@"混在しているパターン", ^{
            beforeEach(^{
                _pocketList.randomIndexPaths[[NSIndexPath indexPathForRow:0 inSection:0]] = [NSIndexPath indexPathForRow:0 inSection:0];
                _pocketList.randomIndexPaths[[NSIndexPath indexPathForRow:0 inSection:1]] = [NSIndexPath indexPathForRow:0 inSection:2];
                _pocketList.randomIndexPaths[[NSIndexPath indexPathForRow:0 inSection:2]] = [NSIndexPath indexPathForRow:0 inSection:4];
            });
            it(@"混在していても正しいbool値を返す", ^{
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) should] beTrue];
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]) should] beFalse];
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]) should] beTrue];
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]]) should] beFalse];
                [[theValue([_pocketList isAddedIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]]) should] beTrue];
            });
        });

    });
});

SPEC_END
