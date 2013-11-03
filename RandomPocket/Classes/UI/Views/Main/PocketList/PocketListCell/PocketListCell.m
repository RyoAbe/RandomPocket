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
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@end

@implementation PocketListCell

- (void)setPocket:(UIPocket*)pocket
{
    _pocket = pocket;
    self.titleLabel.text = _pocket.title;
    self.urlLabel.text = _pocket.url;
    self.thumbnail.image = nil;

    if(!_pocket.imageUrl){
        return;
    }

    AsyncOperation *op = [[AsyncOperation alloc] init];
    [op setDispatchHandler:^id{
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_pocket.imageUrl]]];
    }];
    [op setErrorHandler:^(NSError *error) {
        [self makeToast:[NSString stringWithFormat:@"error: %@", error]];
    }];
    [op setCompletionHandler:^(id result) {
        if(!result) return ;
        self.thumbnail.image = result;
    }];
    [op dispatch];
}

- (CGFloat)cellHeight:(UIPocket*)pocket
{
    if (!pocket || !pocket.title || pocket.title.length == 0){
        pocket.title = pocket.url;
    }
    CGSize size = [pocket.title sizeWithFont:self.titleLabel.font
                           constrainedToSize:CGSizeMake(self.titleLabel.frame.size.width, INT_MAX)
                               lineBreakMode:self.titleLabel.lineBreakMode];
    CGFloat margin = fabs(self.frame.size.height - self.titleLabel.frame.size.height - self.urlLabel.frame.size.height);
    CGFloat cellHeight = size.height + margin + self.urlLabel.frame.size.height;
    
    return cellHeight;
}

@end
