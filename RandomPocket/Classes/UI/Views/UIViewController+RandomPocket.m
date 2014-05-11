//
//  UIViewController+RandomPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/11/04.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIViewController+RandomPocket.h"
#import "RandomPocketUI.h"

@implementation UIViewController (RandomPocket)

- (UINavigationController *)webViewControllerWithURL:(NSString*)url
{
    PBWebViewController *webViewController = [[PBWebViewController alloc] init];
    webViewController.URL = [NSURL URLWithString:url];
    webViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemStop handler:^(id sender) {
        [webViewController dismissViewControllerAnimated:YES completion:nil];
    }];

    return [[UINavigationController alloc] initWithRootViewController:webViewController];
}

- (void)presentLoginViewControllerWithSucceedBlock:(void (^)(void))succeedBlock
                                     cancelBlock:(void (^)(void))cancelBlock
                                      errorBlock:(void (^)(void))errorBlock
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithSucceedBlock:succeedBlock
                                                                                     cancelBlock:cancelBlock
                                                                                      errorBlock:errorBlock];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

@end
