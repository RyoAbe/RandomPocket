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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
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
}

+ (CGFloat)cellHeight:(UIPocket*)pocket
{
    if (!pocket || !pocket.title || pocket.title.length == 0){
        return DefaultCellHeight;
    }
    CGSize size = [pocket.title sizeWithFont:DefaultTitleFont
                           constrainedToSize:CGSizeMake(DefaultTitleRect.size.width, INT_MAX)
                               lineBreakMode:DefaultTitleBreakMode];
    CGFloat margin = fabs(DefaultCellHeight - DefaultTitleRect.size.height - DefaultURLRect.size.height);
    CGFloat cellHeight = size.height + margin + DefaultURLRect.size.height;

    return cellHeight;
}

@end
