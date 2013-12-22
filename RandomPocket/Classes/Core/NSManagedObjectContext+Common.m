//
//  NSManagedObjectContext+Common.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/11/23.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "NSManagedObjectContext+Common.h"
#import "RandomPocketCore.h"

static NSString const * NSManagedObjectContextThreadKey = @"NScontextForThreadKey";

@implementation NSManagedObjectContext (Common)

- (id)createEntity:(NSString *)name
{
    NSEntityDescription* entity = [NSEntityDescription entityForName:name inManagedObjectContext:self];
    NSManagedObject *obj = [[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:self];
    return obj;
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

- (id)existEntityWithName:(NSString*)entyryName fetchRequest:(NSFetchRequest*)fetchRequest
{
    fetchRequest.entity = [NSEntityDescription entityForName:entyryName inManagedObjectContext:self];
    
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

+ (BOOL)save:(NSError **)error
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    BOOL isMainThread = [[NSThread currentThread] isMainThread];
    if (!isMainThread) {
        [[NSNotificationCenter defaultCenter] addObserver:context
                                                 selector:@selector(mergeChanges:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:context];
    }
    BOOL result = [context save:error];
    if (!isMainThread) {
        [[NSNotificationCenter defaultCenter] removeObserver:context
                                                        name:NSManagedObjectContextDidSaveNotification
                                                      object:context];
    }
    return result;
}

- (void)updateMainContext:(NSNotification *)notification
{
    NSAssert([NSThread isMainThread], nil);

    [[NSManagedObjectContext contextForMainThread] save:nil];
    [[NSManagedObjectContext contextForMainThread] mergeChangesFromContextDidSaveNotification:notification];
}

- (void)mergeChanges:(NSNotification *)notification
{    
    NSManagedObjectContext *context = [NSManagedObjectContext contextForMainThread];
    if (notification.object != context) {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:notification waitUntilDone:NO];
    }
}

+ (NSManagedObjectContext *)contextForThread:(NSThread *)thread
{
    NSManagedObjectContext *mainContext = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    if([NSThread isMainThread]){
        return mainContext;
    }
    
    NSMutableDictionary *threadDictionary = [thread threadDictionary];
    NSManagedObjectContext *context = [threadDictionary objectForKey:NSManagedObjectContextThreadKey];
    if (!context) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        context.parentContext = mainContext;
        [threadDictionary setObject:context forKey:NSManagedObjectContextThreadKey];
    }
    return context;
}

+ (NSManagedObjectContext *)contextForCurrentThread
{
    return [NSManagedObjectContext contextForThread:[NSThread currentThread]];
}

+ (NSManagedObjectContext *)contextForMainThread
{
//    NSAssert([NSThread isMainThread], @"This method for main thread");
    return [NSManagedObjectContext contextForThread:[NSThread mainThread]];
}

@end
