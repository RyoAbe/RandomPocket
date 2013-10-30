//
//  PocketDetailCell.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/28.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketDetailCell.h"
#import "RandomPocketUI.h"

@interface PocketDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@end

@implementation PocketDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bodyTextView.layoutManager.delegate = self;
}

- (void)setPocket:(UIPocket *)pocket
{
    _pocket = pocket;
    self.titleLabel.text = _pocket.title;
    self.urlTextView.text = _pocket.url;
    self.bodyTextView.text = _pocket.excerpt;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 5.f;
}

@end
