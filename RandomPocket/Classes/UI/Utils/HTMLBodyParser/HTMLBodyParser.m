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
@property (nonatomic) BOOL isInsideHeadTag;
@property (nonatomic) BOOL isInsideScriptTag;
@property (nonatomic) BOOL isInsideStyleTag;
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

- (void)parseBodyWithCompletionBlock:(void(^)(NSString* body))completionBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *body = self.parseBody;
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(body);
        });
    });
}

- (NSString*)parseBodyWithURL:(NSString*)url
{
    self.url = url;
    return self.parseBody;
}

- (NSString*)parseBody
{
    NSAssert(self.url, nil);
    
    NSError *error;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:&error];
    NSString *pattern = @"<head(.*?)head>|<style(.*?)style>|/\\*(.*?)\\*/|(?is)<(script|style).*?>.*?(</\1>)|(?s)<!--(.*?)-->[\n]?|<.*?>.*?>|<[^>]*?>|\n|\r|\t| |　";
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                            options:0
                                                                              error:nil];
    NSMutableString *body = [NSMutableString new];
    NSRange range = NSMakeRange( 0, [html length]);
    while ( range.length > 0 )
    {
        NSRange subrange = [html lineRangeForRange:NSMakeRange( range.location, 0 )];
        NSString *line = [html substringWithRange:subrange];

        if([self isInsideHeadTag:line] || [self isInsideScriptTag:line] || [self isInsideStypeTag:line]){
            range.location = NSMaxRange( subrange );
            range.length -= subrange.length;
            continue;
        }

        line = [regexp stringByReplacingMatchesInString:line
                                                options:0
                                                  range:NSMakeRange(0, line.length)
                                           withTemplate:@""];
        
        if(line != nil && line.length != 0){
            [body appendString:line];
        }
        range.location = NSMaxRange( subrange );
        range.length -= subrange.length;
    }
    
    return body;
}

- (BOOL)isInsideHeadTag:(NSString*)line
{
    if([self isTag1LineBeginEnd:@"head" line:line]){
        return YES;
    }
    
    if(_isInsideHeadTag){
        _isInsideHeadTag =  ![self matchString:@"/head>" line:line];
    }else{
        if([self matchString:@"<header" line:line]){
            return NO;
        }
        _isInsideHeadTag =  [self matchString:@"<head" line:line];
    }
    
    return _isInsideHeadTag;
}

- (BOOL)isInsideScriptTag:(NSString*)line
{
    if([self isTag1LineBeginEnd:@"script" line:line]){
        return YES;
    }
    _isInsideScriptTag = _isInsideScriptTag ? ![self matchString:@"/script>" line:line] : [self matchString:@"<script" line:line];
    
    return _isInsideScriptTag;
}

- (BOOL)isInsideStypeTag:(NSString*)line
{
    if([self isTag1LineBeginEnd:@"style" line:line]){
        return YES;
    }
    _isInsideStyleTag = _isInsideStyleTag ? ![self matchString:@"/style>" line:line] : [self matchString:@"<style" line:line];
    
    return _isInsideStyleTag;
}

- (BOOL)isTag1LineBeginEnd:(NSString*)tag line:(NSString*)line
{
    BOOL beginTag = [self matchString:[NSString stringWithFormat:@"<%@", tag] line:line];
    BOOL endTag = [self matchString:[NSString stringWithFormat:@"/%@>", tag] line:line];
    if(beginTag && endTag){
        return YES;
    }
    return NO;
}

- (BOOL)matchString:(NSString*)string line:(NSString*)line
{
    NSRange range = [line rangeOfString:string];
    BOOL isMatch = NO;
    if(range.location != NSNotFound){
        isMatch = YES;
    }
    return isMatch;
}

@end
