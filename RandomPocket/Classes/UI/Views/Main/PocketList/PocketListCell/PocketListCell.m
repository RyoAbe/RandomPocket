//
//  PocketCell.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketListCell.h"

@interface PocketListCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *favicon;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@end

static const CGFloat AdjustmentHeight = 1;

@implementation PocketListCell

- (void)setPocket:(UIPocket*)pocket
{
    _pocket = pocket;
    self.titleLabel.text = _pocket.title;
    self.urlLabel.text = _pocket.url;
    [self.favicon setImageWithURL:_pocket.faviconURL];
    
    self.thumbnail.image = nil;
    if(!_pocket.imageUrl){
        return;
    }
    [self.thumbnail setImageWithURL:[NSURL URLWithString:_pocket.imageUrl]];
}

- (CGFloat)cellHeightWithTitle:(NSString*)title
{
    if(!title){
        return self.frame.size.height;
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title
                                                                    attributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGSize size = [attString boundingRectWithSize:CGSizeMake(self.titleLabel.frame.size.width, INT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat margin = fabsf(self.frame.size.height - self.titleLabel.frame.size.height - self.urlLabel.frame.size.height);
    CGFloat cellHeight = size.height + margin + self.urlLabel.frame.size.height;

    // boundingRectWithSizeの結果が少し小さくなってしまうので調整用に高さを足す
    return cellHeight + AdjustmentHeight;
}

@end
