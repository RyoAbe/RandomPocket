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
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailHeight;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailTopSpace;
@property (weak, nonatomic) IBOutlet UIImageView *favicon;
@end

@implementation PocketDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bodyTextView.layoutManager.delegate = self;
    [self.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkTapped:)]];
}

- (void)setPocket:(UIPocket *)pocket
{
    _pocket = pocket;
    self.titleLabel.text = _pocket.title;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_pocket.url];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                             range:NSMakeRange(0, _pocket.url.length)];
    [self.urlButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    self.bodyTextView.text = _pocket.excerpt;
    [self.favicon setImageWithURL:_pocket.faviconURL];
    
    self.thumbnail.image = nil;
    self.thumbnailHeight.constant = self.thumbnailTopSpace.constant = 0;

    if(!_pocket.imageUrl){
        return;
    }
    [self.thumbnail setImageWithURL:[NSURL URLWithString:_pocket.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(!image) return ;
        self.thumbnailHeight.constant = 150;
        self.thumbnailTopSpace.constant = 5;
    }];
}
- (IBAction)linkTapped:(id)sender
{
    UINavigationController *webViewController = [self.vc webViewControllerWithURL:_pocket.url];
    [self.vc.navigationController presentViewController:webViewController animated:YES completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 5.f;
}

@end
