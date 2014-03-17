//
//  UIViewController+RandomPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/11/04.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RandomPocket)
- (UINavigationController *)webViewControllerWithURL:(NSString*)url;
- (void)presentLoginViewControllerWithSucceedBlock:(void (^)(void))succeedBlock
                                       cancelBlock:(void (^)(void))cancelBlock
                                        errorBlock:(void (^)(void))errorBlock;
@end
