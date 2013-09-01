//
//  HTMLParser.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/30.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLBodyParser : NSObject
- (id)initWithURL:(NSString*)url;
- (void)parseWithCompletionBlock:(void(^)(NSString* body))completionBlock;
@end
