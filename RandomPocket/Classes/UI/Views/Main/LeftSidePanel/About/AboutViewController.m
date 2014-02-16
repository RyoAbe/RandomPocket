//
//  AboutViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/02/03.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "AboutViewController.h"
#import "RandomPocketUI.h"

typedef NS_ENUM(int, AbountViewSectionType) {
    AbountViewSectionTypeAppInfo = 0,
    AbountViewSectionTypeCoutactUs,
};

typedef NS_ENUM(int, AbountViewRowType) {
    AbountViewRowTypeReviewAppStore = 0,
//    AbountViewRowTypeReviewAppSite,
    AbountViewRowTypeReviewTerms,
    AbountViewRowTypeReviewLicense,
    AbountViewRowTypeReviewTwitter = 0,
    AbountViewRowTypeReviewDeveloperWebsite,
};

@interface AboutViewController ()

@end

@implementation AboutViewController

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
	// Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case AbountViewSectionTypeAppInfo:
            switch (indexPath.row) {
                case AbountViewRowTypeReviewAppStore:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/"]];
                    break;
                case AbountViewRowTypeReviewTerms:
                    break;
                case AbountViewRowTypeReviewLicense:
                    break;
            }
            break;
        case AbountViewSectionTypeCoutactUs:
            switch (indexPath.row) {
                case AbountViewRowTypeReviewTwitter:
                    [UIUtil openInSafariOrChrome:[NSURL URLWithString:@"https://twitter.com/RyoAbe/"]];
                    break;
                case AbountViewRowTypeReviewDeveloperWebsite:
                    [UIUtil openInSafariOrChrome:[NSURL URLWithString:@"http://ryoabe.com/"]];
                    break;
            }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
