//
//  LogoutOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/02/09.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "LogoutOperation.h"
#import "RandomPocketUI.h"

@implementation LogoutOperation

- (id)init
{
    self = [super init];
    if (self) {
        [self setDispatchHandler:^id{
            [[PocketAPI sharedAPI] logout];
            [NSManagedObjectContext deleteEntities];
            return nil;
        }];
    }
    return self;
}

@end
