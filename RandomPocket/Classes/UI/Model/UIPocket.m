//
//  UIPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIPocket.h"

@implementation UIPocket

- (id)initWithData:(NSDictionary*)data
{
    self = [super init];
    if (self) {
        self.data = data;
        self.url = data[@"resolved_url"];
        NSLog(@"data : %@", [data description]);
        NSString* title = data[@"resolved_title"];
        if(title.length == 0){
            title = data[@"given_title"];
        }
        self.title = title;
    }
    return self;
}

@end
