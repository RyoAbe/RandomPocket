//
//  PocketCell.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketListCell.h"

@implementation PocketListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[UINib nibWithNibName:@"PocketListCell" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPocket:(UIPocket *)pocket
{
    _pocket = pocket;
    self.titleLabel.text = _pocket.title;
    self.urlLabel.text = _pocket.url;
}

@end
