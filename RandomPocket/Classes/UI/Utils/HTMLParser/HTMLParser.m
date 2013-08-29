//
//  HTMLParser.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/30.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "HTMLParser.h"

@interface HTMLParser()
@property (nonatomic) NSString *url;
@end

@implementation HTMLParser

- (id)initWithURL:(NSString*)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)parseWithCompletionBlock:(void(^)(NSString* body))completionBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *body = self.body;
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(body);
        });
    });
}

- (NSString*)body
{
    NSError *error;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:&error];
    
    NSMutableString *body = [NSMutableString new];
    NSRange range = NSMakeRange( 0, [html length] );
    while ( range.length > 0 )
    {
        NSRange subrange = [html lineRangeForRange:NSMakeRange( range.location, 0 )];
        NSString *line = [html substringWithRange:subrange];
        line = [line stringByReplacingOccurrencesOfString:@" " withString:@""];
        line = [line stringByReplacingOccurrencesOfString:@"　" withString:@""];
        line = [line stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        line = [line stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"( .+)"
                                                  options:0
                                                    error:nil];
        if(line != nil &&line.length != 0){
            [body appendString:line];
        }
        range.location = NSMaxRange( subrange );
        range.length -= subrange.length;
    }
    return body;
}

@end
