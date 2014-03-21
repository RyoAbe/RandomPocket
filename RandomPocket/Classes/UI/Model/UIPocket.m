//
//  UIPocket.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIPocket.h"

@interface UIPocket()
@property (nonatomic) CPocket *cPocket;
@end

@implementation UIPocket

- (id)initWithCPocket:(CPocket*)cPocket
{
    self = [super init];
    if (self) {
        self.url = cPocket.url;
        self.title = cPocket.title;
        self.body = cPocket.body;
        self.timeAdded = cPocket.timeAdded;
        self.excerpt = cPocket.excerpt;
        self.imageUrl = cPocket.imageUrl;
        self.cPocket = cPocket;
        self.objectID = cPocket.objectID;
        self.itemID = cPocket.itemID;
    }
    return self;
}

- (NSURL *)faviconURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@", [[NSURL URLWithString:self.url] host]]];
}

- (void)setTitle:(NSString *)title
{
    if(!title || title.length == 0){
        title = self.url;
    }
    _title = title;
}

@end
