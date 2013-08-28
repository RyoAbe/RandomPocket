//
//  UIPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIPocket.h"

static NSString* const UNKNOWN_TITLE = @"Unknown Title";

@implementation UIPocket

- (id)initWithData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        self.data = data;
        self.url = data[@"resolved_url"];
        self.title = data[@"resolved_title"];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if(title.length == 0){
        title = self.data[@"given_title"];
    }
    if(title.length == 0){
        title = UNKNOWN_TITLE;
    }
    _title = title;
}

@end
