//
//  MRProgressOverlayView+RandomPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/12/21.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "RandomPocketUI.h"

@interface MRProgressOverlayView (RandomPocket)
+ (instancetype)showWithTitle:(NSString*)title;
+ (instancetype)showWithTitle:(NSString*)title mode:(MRProgressOverlayViewMode)mode;
- (void)hide;
@end
