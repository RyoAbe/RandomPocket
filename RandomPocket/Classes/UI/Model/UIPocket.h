//
//  UIPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomPocketUI.h"

@interface UIPocket : NSObject

- (id)initWithData:(NSDictionary*)data;
- (id)initWithCPocket:(CPocket*)cPocket;

@property (nonatomic) NSManagedObjectID *objectID;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *body;
@property (nonatomic) NSDate *entryDate;
@property (nonatomic) NSDictionary* data;

@end
