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

- (void)mergeChanges:(NSNotification*)notification
{
    NSManagedObjectContext *contextFromNotification = notification.object;
    [contextFromNotification performSelectorOnMainThread:@selector(updateMainContext:)
                                              withObject:notification
                                           waitUntilDone:YES];
//    [contextFromNotification performBlock:^{
//        [[NSManagedObjectContext contextForMainThread] mergeChangesFromContextDidSaveNotification:notification];
//    }];
}

- (void)updateMainContext:(NSNotification *)notification
{
    [[NSManagedObjectContext contextForMainThread] mergeChangesFromContextDidSaveNotification:notification];
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
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[mainContext persistentStoreCoordinator]];
        [threadDictionary setObject:context forKey:NSManagedObjectContextThreadKey];
        
//        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        context.parentContext = mainContext;
//        //        context = [[NSManagedObjectContext alloc] init];
//        //        [context setPersistentStoreCoordinator:[mainContext persistentStoreCoordinator]];
//        [threadDictionary setObject:context forKey:NSManagedObjectContextThreadKey];
        
    }
    return context;
}

+ (NSManagedObjectContext *)contextForCurrentThread
{
    return [NSManagedObjectContext contextForThread:[NSThread currentThread]];
}

+ (NSManagedObjectContext *)contextForMainThread
{
    NSAssert([NSThread isMainThread], @"This method for main thread");
    return [NSManagedObjectContext contextForThread:[NSThread mainThread]];
}

@end
