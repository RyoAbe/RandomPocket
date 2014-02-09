//
//  MRProgressOverlayView+RandomPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/12/21.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "MRProgressOverlayView+RandomPocket.h"

@implementation MRProgressOverlayView (RandomPocket)

+ (instancetype)showWithTitle:(NSString*)title
{
    return [self showWithTitle:title mode:MRProgressOverlayViewModeIndeterminate];
}

+ (instancetype)showWithTitle:(NSString*)title mode:(MRProgressOverlayViewMode)mode
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if([window viewWithTag:RandomPocketViewTag_MRProgressOverlayView]){
        [[window viewWithTag:RandomPocketViewTag_MRProgressOverlayView] removeFromSuperview];
    }
    MRProgressOverlayView *view = [self new];
    view.tag = RandomPocketViewTag_MRProgressOverlayView;
    view.mode = mode;
    view.titleLabelText = title;
    [window addSubview:view];
    [view show:YES];
    return view;
}

- (void)hide
{
    [self dismiss:YES];
}

@end
