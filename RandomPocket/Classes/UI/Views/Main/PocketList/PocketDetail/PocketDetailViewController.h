//
//  PocketDetailViewController.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPocketUI.h"

@interface PocketDetailViewController : UIViewController
@property (nonatomic) UIPocket *pocket;
@property (nonatomic) UIPocketList *pocketList;
@end
