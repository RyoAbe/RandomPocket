//
//  PocketDetailCell.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/28.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIPocket;
@class PocketSwipeViewController;

@interface PocketDetailCell : UICollectionViewCell<NSLayoutManagerDelegate>
@property (nonatomic) UIPocket* pocket;
@property (nonatomic, weak) PocketSwipeViewController* vc;
@end
