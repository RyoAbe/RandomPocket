//
//  PocketSwipeViewController.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/28.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPocketUI.h"

@interface PocketSwipeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) NSUInteger selectedPocketIndex;
@property (nonatomic) UIPocketList *pocketList;
@end
