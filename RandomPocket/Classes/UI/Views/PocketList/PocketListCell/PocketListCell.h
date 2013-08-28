//
//  PocketCell.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPocketUI.h"

@interface PocketListCell : UITableViewCell
@property (nonatomic) UIPocket *pocket;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
+ (CGFloat)cellHeight:(UIPocket*)pocket;
@end
