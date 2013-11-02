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
            self.loginButton.enabled = YES;
            self.loginButton.alpha = 1.f;
            [self.view makeToast:NSLocalizedStringFromTable(@"FaildLogin", @"Welcom", nil)];
            NSAssert(NO, error.localizedDescription);
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

@end
