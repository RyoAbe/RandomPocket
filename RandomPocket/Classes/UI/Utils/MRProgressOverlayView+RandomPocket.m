//
//  MRProgressOverlayView+RandomPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/12/21.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "MRProgressOverlayView+RandomPocket.h"

@interface MRProgressOverlayView()
- (void)commonInit;
- (void)unregisterFromKVO;
- (void)unregisterFromNotificationCenter;
@end

@implementation MRProgressOverlayView (RandomPocket)

+ (instancetype)createProgressView
{
    MRProgressOverlayView *view = [self new];
    view.hidden = YES;
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    return view;
}

- (void)prepare
{
    [self unregisterFromKVO];
    [self unregisterFromNotificationCenter];
    [self commonInit];
}

- (void)showWithTitle:(NSString*)title
{
    if(!self.hidden){
        return;
    }
    [self prepare];
    self.titleLabelText = title;
    [self show:YES];
}

- (void)hide
{
    [self hide:YES];
}

@end
