//
//  UIPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomPocketCore.h"

@interface UIPocket : NSObject

- (id)initWithCPocket:(CPocket*)cPocket;

@property (nonatomic) NSManagedObjectID *objectID;
@property (nonatomic) NSString *itemID;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *body;
@property (nonatomic) NSDate *timeAdded;
@property (nonatomic) NSString *excerpt;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSDictionary* data;
@property (nonatomic, readonly) NSURL *faviconURL;

@end
