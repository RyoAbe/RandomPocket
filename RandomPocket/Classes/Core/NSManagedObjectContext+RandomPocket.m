//
//  NSManagedObjectContext+RandomPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/05.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "NSManagedObjectContext+RandomPocket.h"

@implementation NSManagedObjectContext (RandomPocket)

- (id)createEntity:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}

- (id)entityWithID:(NSManagedObjectID*)objectID
{
    NSError *error;
    NSManagedObject* obj = [self existingObjectWithID:objectID error:&error];
    return obj;
}

@end
