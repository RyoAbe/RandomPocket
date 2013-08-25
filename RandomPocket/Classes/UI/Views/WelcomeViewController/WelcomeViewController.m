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
- (IBAction)authenticationButtonTapped:(id)sender;

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

- (IBAction)authenticationButtonTapped:(id)sender
{
    [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error) {
        if(error){
            NSLog(@"error");
        }else{
            NSLog(@"success");
        }
    }];
}
@end
