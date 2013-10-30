//
//  HTMLParser.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/30.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLBodyParser : NSObject
@property (nonatomic) NSString *url;
- (id)initWithURL:(NSString*)url;
- (NSString*)parseBody;
- (NSString*)parseBodyWithURL:(NSString*)url;
- (void)parseBodyWithCompletionBlock:(void(^)(NSString* body))completionBlock;
@end
