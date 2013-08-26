//
//  UIPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPocket : NSObject

- (id)initWithData:(NSDictionary*)data;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* title;

@end
