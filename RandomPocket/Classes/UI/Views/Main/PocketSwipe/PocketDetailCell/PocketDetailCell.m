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
    [self.urlButton setTitle:_pocket.url forState:UIControlStateNormal];
    self.bodyTextView.text = _pocket.excerpt;
    self.thumbnail.image = nil;
    self.thumbnailHeight.constant = self.thumbnailTopSpace.constant = 0;

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
        self.thumbnailHeight.constant = 150;
        self.thumbnailTopSpace.constant = 5;
        self.thumbnail.image = result;
    }];
    [op dispatch];

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
