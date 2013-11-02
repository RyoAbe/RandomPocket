//
//  PocketCell.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketListCell.h"

static CGFloat DefaultCellHeight;
static CGRect DefaultTitleRect;
static UIFont *DefaultTitleFont;
static NSLineBreakMode DefaultTitleBreakMode;
static CGRect DefaultURLRect;

@interface PocketListCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailWidth;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@end

@implementation PocketListCell

+ (void)initialize
{
    [super initialize];
    if (self == [PocketListCell class])
    {
        // セルの高さやラベルの高さを取得するために一度nibファイルを読み込んでいる（がもう少しいい方法はないだろうか、、）
        PocketListCell *cell = [[[UINib nibWithNibName:@"PocketListCell" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
        [cell prepare];
    }
}

- (void)prepare
{
    DefaultCellHeight = self.frame.size.height;
    DefaultTitleRect = self.titleLabel.frame;
    DefaultTitleBreakMode = self.titleLabel.lineBreakMode;
    DefaultTitleFont = self.titleLabel.font;
    DefaultURLRect = self.urlLabel.frame;
}

- (void)setPocket:(UIPocket*)pocket
{
    _pocket = pocket;
    self.titleLabel.text = _pocket.title;
    self.urlLabel.text = _pocket.url;
    self.thumbnail.image = nil;
    self.thumbnailWidth.constant = 0;

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
        self.thumbnailWidth.constant = 80;
    }];
    [op dispatch];
}

+ (CGFloat)cellHeight:(UIPocket*)pocket
{
    if (!pocket || !pocket.title || pocket.title.length == 0){
        pocket.title = pocket.url;
    }
    CGSize size = [pocket.title sizeWithFont:DefaultTitleFont
                           constrainedToSize:CGSizeMake(DefaultTitleRect.size.width, INT_MAX)
                               lineBreakMode:DefaultTitleBreakMode];
    CGFloat margin = fabs(DefaultCellHeight - DefaultTitleRect.size.height - DefaultURLRect.size.height);
    CGFloat cellHeight = size.height + margin + DefaultURLRect.size.height;

    return cellHeight;
}

@end
