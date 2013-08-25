//
//  ViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/25.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RandomPocketUI.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(id)sender
{
    self.loginButton.enabled = NO;
    self.loginButton.alpha = 0.5f;

    [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error) {
        if(error){
            [self.view makeToast:NSLocalizedStringFromTable(@"FaildLogin", @"Welcom", nil)];
            return ;
        }
        [self performSegueWithIdentifier:@"PocketListSegue" sender:self];
    }];
}
@end
