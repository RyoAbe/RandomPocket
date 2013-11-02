//
//  PocketCell.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPocketUI.h"
#import "UIPocket.h"

@interface PocketListCell : UITableViewCell
@property (nonatomic) UIPocket *pocket;
- (CGFloat)cellHeight:(UIPocket*)pocket;
@end
