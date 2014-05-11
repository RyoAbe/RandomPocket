//
//  AddNewItemFromClipboardController.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/04/12.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "AddNewItemFromClipboardController.h"
#import "AddNewItemView.h"

@interface AddNewItemFromClipboardController()
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation AddNewItemFromClipboardController

- (id)initWithViewController:(UIViewController*)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)showAddViewIfClipboardIsURL
{
    NSString *clipboardText = [[UIPasteboard generalPasteboard] valueForPasteboardType:@"public.text"];
    if([clipboardText hasPrefix:@"http://"] || [clipboardText hasPrefix:@"https://"]){
        [self showAddNewItemView];
    }
}

- (void)showAddNewItemView
{
    AddNewItemView *view = [AddNewItemView loadFromNib];
    CGRect frame = view.frame;
    frame.origin.y = self.viewController.view.frame.size.height - frame.size.height;
    view.frame = frame;
}

@end
