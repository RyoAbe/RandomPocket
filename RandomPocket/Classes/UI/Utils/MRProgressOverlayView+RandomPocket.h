//
//  MRProgressOverlayView+RandomPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/12/21.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "RandomPocketUI.h"

@interface MRProgressOverlayView (RandomPocket)
+ (instancetype)createProgressView;
- (void)showWithTitle:(NSString*)title;
- (void)hide;
@end
