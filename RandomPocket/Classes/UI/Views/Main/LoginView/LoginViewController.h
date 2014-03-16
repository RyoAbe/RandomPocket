//
//  LoginViewController.h
//  RandomPocket
//
//  Created by RyoAbe on 2014/03/16.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

- (id)initWithSucceedBlock:(void (^)(void))succeedBlock
               cancelBlock:(void (^)(void))cancelBlock
                errorBlock:(void (^)(void))errorBlock;

@end
