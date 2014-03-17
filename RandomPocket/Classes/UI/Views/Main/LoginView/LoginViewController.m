//
//  LoginViewController.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/03/16.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "LoginViewController.h"
#import "RandomPocketUI.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, copy) void (^succeedBlock)();
@property (nonatomic, copy) void (^errorBlock)();
@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic) UITapGestureRecognizer *viewTapGestureRecognizer;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSucceedBlock:(void (^)(void))succeedBlock
               cancelBlock:(void (^)(void))cancelBlock
                errorBlock:(void (^)(void))errorBlock
{
    self = [super init];
    if (self) {
        self.succeedBlock = succeedBlock;
        self.cancelBlock = cancelBlock;
        self.errorBlock = errorBlock;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.9f];
    self.viewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self cancelButtonTapped:sender];
    }];
    [self.view addGestureRecognizer:self.viewTapGestureRecognizer];
}

- (IBAction)loginButtonTapped:(UIButton*)sender
{
    [self buttonEnable:NO];
    [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error) {
        if(error) {
            if(self.errorBlock) { self.errorBlock(); }
        }else{
            if(self.succeedBlock) { self.succeedBlock(); }
        }
        [self dismissViewControllerAnimated:YES completion:^{
            [self buttonEnable:YES];
        }];
    }];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    if(self.cancelBlock) { self.cancelBlock(); }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonEnable:(BOOL)enable
{
    self.loginButton.enabled = self.cancelButton.enabled = enable;
    self.viewTapGestureRecognizer.enabled = enable;
    self.loginButton.alpha = self.cancelButton.alpha = enable ? 1 : 0.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    RALog(@"");
}

@end
