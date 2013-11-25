//
//  PocketCell.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPocketUI.h"

@interface PocketListCell : MSCMoreOptionTableViewCell
@property (nonatomic) UIPocket *pocket;
- (CGFloat)cellHeight:(UIPocket*)pocket;
@end
