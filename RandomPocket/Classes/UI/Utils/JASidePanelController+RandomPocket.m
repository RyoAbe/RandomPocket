//
//  JASidePanelController+RandomPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/02/03.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "JASidePanelController+RandomPocket.h"
#import "RandomPocketUI.h"

@implementation JASidePanelController (RandomPocket)

+ (JASidePanelController*)createSidePanelController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JASidePanelController *sidePanelController = [[JASidePanelController alloc] init];
    sidePanelController.leftPanel = [storyboard instantiateViewControllerWithIdentifier:@"LeftSidePanelView"];
    sidePanelController.centerPanel = [sidePanelController createCenterPanel:[storyboard instantiateInitialViewController]];
    return sidePanelController;
}

- (UIViewController*)createCenterPanel:(UIViewController*)viewController
{
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self action:@selector(toggleLeftPanel:)];
    if([viewController isKindOfClass:[UINavigationController class]]){
        UIViewController *rootViewController = ((UINavigationController*)viewController).viewControllers[0];
        rootViewController.navigationItem.leftBarButtonItem = menuBarButtonItem;
        return viewController;
    }
    viewController.navigationItem.leftBarButtonItem = menuBarButtonItem;
    return viewController;
}

@end
