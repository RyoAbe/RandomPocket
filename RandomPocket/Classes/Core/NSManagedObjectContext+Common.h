//
//  NSManagedObjectContext+Common.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/11/23.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Common)
- (id)createEntity:(NSString *)name;
- (id)entityWithID:(NSManagedObjectID*)objectID;
- (id)existEntityWithName:(NSString*)entyryName fetchRequest:(NSFetchRequest*)fetchRequest;
+ (NSManagedObjectContext *)contextForCurrentThread;
+ (NSManagedObjectContext *)contextForMainThread;
+ (BOOL)save:(NSError **)error;
+ (NSError*)deleteEntities;
@end
