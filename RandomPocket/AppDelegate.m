//
//  AppDelegate.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/25.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "AppDelegate.h"
#import "RandomPocketCore.h"
#import "RandomPocketUI.h"

@interface AppDelegate()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Pocket
    [[PocketAPI sharedAPI] setConsumerKey:@"17789-2ae60ad9c498ad18d6cc31dd"];
    
#ifndef DEBUG
    // Appirater
    [self appirater];

    // Crittercism
    [Crittercism enableWithAppID:@"52f787ba8b2e3333c3000002"];
#endif

    _managedObjectContext = [self createManagedObjectContext];
    
    [self appearance];

    self.window.rootViewController = [JASidePanelController createSidePanelController];

    return YES;
}

- (void)appirater
{
    [Appirater setAppId:@"852282288"];
    [Appirater appLaunched:YES];
    [Appirater setDaysUntilPrompt:30];
    [Appirater setUsesUntilPrompt:20];
    [Appirater setTimeBeforeReminding:1];
    [Appirater setDebug:NO];
}

- (void)appearance
{
    [[UINavigationBar appearance] setTintColor:[RPColor NavigationBarColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[RPColor NavigationBarTitleColor],
                                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:20],}];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[RPColor BarButtonItemColor]];
    [[UIToolbar appearance] setTintColor:[RPColor NavigationBarColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:[RPColor ToolButtonItemColor]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([[PocketAPI sharedAPI] handleOpenURL:url]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Core Data

- (NSManagedObjectContext *)createManagedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (void)recreateManagedObjectContext
{
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    self.managedObjectContext = [self createManagedObjectContext];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RandomPocket" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error]) {
        NSAssert(NO, error.userInfo.description);
    }
    return _persistentStoreCoordinator;
}

- (NSURL*)storeURL
{
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [applicationDocumentsDirectory URLByAppendingPathComponent:@"RandomPocket.sqlite"];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSAssert(NO, error.userInfo.description);
        }
    }
}

#pragma mark - 
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

@end
