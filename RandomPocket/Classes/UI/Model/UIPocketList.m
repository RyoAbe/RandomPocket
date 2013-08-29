//
//  UIPocketList.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIPocketList.h"
#import "RandomPocketUI.h"

static NSInteger const NumberOfSections = 1;

@implementation UIPocketList

- (NSInteger)numberOfSections
{
    return NumberOfSections;
}

- (NSUInteger)numberOfItems
{
    return self.response.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.response.count;
}

- (NSIndexPath*)indexPathForObject:(UIPocket*)pocket
{
    NSInteger index = [self.response indexOfObject:pocket];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:NumberOfSections];
    return indexPath;
}

- (NSInteger)indexForObject:(UIPocket*)pocket
{
    NSInteger index = [self.response indexOfObject:pocket];
    return index;
}

- (UIPocket*)objectAtIndex:(NSUInteger)index
{
    return self.response[index];
}

- (UIPocket*)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return self.response[indexPath.row];
}

@end
