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
    sidePanelController.centerPanel = [storyboard instantiateInitialViewController];
    return sidePanelController;
}

@end
