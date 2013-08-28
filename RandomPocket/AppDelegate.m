//
//  AppDelegate.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/25.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "AppDelegate.h"
#import "RandomPocketLibrary.h"
#import "RandomPocketUI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PocketAPI sharedAPI] setConsumerKey:@"17789-2ae60ad9c498ad18d6cc31dd"];

    NSString *storyBoardName = @"Welcom";
    if([PocketAPI sharedAPI].username){
        storyBoardName = @"PocketList";
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    self.window.rootViewController = vc;
    
    [self appearance];

    return YES;
}

- (void)appearance
{
    [[UINavigationBar appearance] setTintColor:[RPColor NavigationBarColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                UITextAttributeTextColor:[RPColor NavigationBarTitleColor],
                          UITextAttributeTextShadowColor:[UIColor clearColor],
                         UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero],
                                     UITextAttributeFont:[UIFont boldSystemFontOfSize:20],
     
     }];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[RPColor BarButtonItemColor]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([[PocketAPI sharedAPI] handleOpenURL:url]){
        return YES;
    }else{
        return NO;
    }
}
							
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
