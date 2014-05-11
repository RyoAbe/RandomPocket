//
//  AddNewItemFromClipboardController.h
//  RandomPocket
//
//  Created by RyoAbe on 2014/04/12.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddNewItemFromClipboardController : NSObject

- (id)initWithViewController:(UIViewController*)viewController;
- (void)showAddViewIfClipboardIsURL;
@end
