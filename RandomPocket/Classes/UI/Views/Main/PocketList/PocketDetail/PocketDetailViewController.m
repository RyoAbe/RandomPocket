//
//  PocketDetailViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/27.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "PocketDetailViewController.h"

@interface PocketDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@end

@implementation PocketDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSInteger index = [self.pocketList indexForObject:self.pocket];
    self.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"NavigationTitleFormat", @"PocketDetail", nil), index, self.pocketList.numberOfItems];
    self.titleLabel.text = self.pocket.title;
    self.urlLabel.text = self.pocket.url;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.titleLabel sizeToFit];
}

@end
