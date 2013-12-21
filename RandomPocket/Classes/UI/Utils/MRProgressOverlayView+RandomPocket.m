//
//  MRProgressOverlayView+RandomPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/12/21.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "MRProgressOverlayView+RandomPocket.h"

@implementation MRProgressOverlayView (RandomPocket)

+ (instancetype)createProgressView
{
    MRProgressOverlayView *view = [self new];
    view.hidden = YES;
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    return view;
}

- (void)showWithTitle:(NSString*)title
{
    if(!self.hidden){
        return;
    }
    self.titleLabelText = title;
    [self show:YES];
}

- (void)hide
{
    [self hide:YES];
}

@end
