//
//  HTMLParser.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/30.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "HTMLBodyParser.h"
#import "HTMLParser.h"

@interface HTMLBodyParser()
@property (nonatomic) NSString *url;
@end

@implementation HTMLBodyParser

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

//- (NSString*)body
//{
//    NSError *error;
//    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:&error];
//    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
//
//    NSAssert(!error, nil);
//    
//    HTMLNode *bodyNode = [parser body];
//    NSArray *inputNodes = [bodyNode findChildTags:@"div"];
//    NSMutableString *body = [NSMutableString new];
//    for (HTMLNode *inputNode in inputNodes) {
//        if([inputNode contents]){
//            [body appendString:[inputNode contents]];
//        }
//    }
//    return body;
//}

- (NSString*)body
{
    NSError *error;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:&error];
    NSString *pattern = @"<style(.*?)style>|/\\*(.*?)\\*/|(?is)<(script|style).*?>.*?(</\1>)|(?s)<!--(.*?)-->[\n]?|<[^>]*?>|\n|\r| |　";
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                            options:0
                                                                              error:nil];
    NSMutableString *body = [NSMutableString new];
    NSRange range = NSMakeRange( 0, [html length]);
    while ( range.length > 0 )
    {
        NSRange subrange = [html lineRangeForRange:NSMakeRange( range.location, 0 )];
        NSString *line = [html substringWithRange:subrange];
        line = [regexp stringByReplacingMatchesInString:line
                                                options:0
                                                  range:NSMakeRange(0, line.length)
                                           withTemplate:@""];
        
        if(line != nil && line.length != 0){
            [body appendString:line];
            NSLog(@"%@", line);
        }
        range.location = NSMaxRange( subrange );
        range.length -= subrange.length;
    }
    return body;
}

@end
