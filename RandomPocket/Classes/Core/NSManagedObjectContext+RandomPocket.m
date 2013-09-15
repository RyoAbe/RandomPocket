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

- (id)createEntity:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

- (id)entityWithID:(NSManagedObjectID*)objectID
{
    NSError *error;
    NSManagedObject* obj = [self existingObjectWithID:objectID error:&error];
    if(error){
        NSAssert(NO, [[error userInfo] description]);
    }
    return obj;
}


- (CPocket*)pocketWithItemID:(NSString*)itemID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"itemID == %@", itemID];
    CPocket *cPocket = [self existEntityWithName:@"CPocket" fetchRequest:fetchRequest];

    return cPocket;
}

- (id)existEntityWithName:(NSString*)entyryName fetchRequest:(NSFetchRequest*)fetchRequest
{
    fetchRequest.entity = [NSEntityDescription entityForName:@"CPocket" inManagedObjectContext:self];
   
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSAssert(NO, error.userInfo.description);
    }

    if(results.count > 1){
        NSAssert(NO, @"should be result count is 0 or 1.");
    }else if(results.count == 0){
        return nil;
    }
    return results[0];
}

@end
