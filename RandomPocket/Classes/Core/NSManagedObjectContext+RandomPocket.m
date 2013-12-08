//
//  NSManagedObjectContext+RandomPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/05.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "NSManagedObjectContext+RandomPocket.h"
#import "RandomPocketCore.h"

@implementation NSManagedObjectContext (RandomPocket)

- (CPocket*)pocketWithItemID:(NSString*)itemID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"itemID == %@", itemID];
    return [self existEntityWithName:@"CPocket" fetchRequest:fetchRequest];
}

@end