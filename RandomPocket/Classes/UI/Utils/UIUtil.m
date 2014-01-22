//
//  UIUtil.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/01/18.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "UIUtil.h"

static NSString * const kGoogleChromeHTTPScheme = @"googlechrome:";
static NSString * const kGoogleChromeHTTPSScheme = @"googlechromes:";
static NSString * const kGoogleChromeCallbackScheme = @"googlechrome-x-callback:";

@implementation UIUtil

+ (void)openInEvernoteWithURL:(NSString*)url title:(NSString*)title
{
    NSString *clipURL = [NSString stringWithFormat:@"http://s.evernote.com/grclip?url=%@&title=%@",
                         encodeByAddingPercentEscapes(url), encodeByAddingPercentEscapes(title)];
    [UIUtil openInSafariOrChrome:[NSURL URLWithString:clipURL]];
}

+ (void)openInSafariOrChrome:(NSURL*)url
{
    if ([self isChromeInstalled]) {
        [self openInChrome:url];
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Open In Chrome

/**
 *  Chromeで開く
 *
 *  @param url
 *  @see https://developers.google.com/chrome/mobile/docs/ios-links?hl=ja
 */
+ (void)openInChrome:(NSURL *)url
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *callbackURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [bundle infoDictionary][@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0], @"://"]];
    if (![url.scheme isEqualToString:@"http"] && ![url.scheme isEqualToString:@"https"]) {
        return;
    }
    NSString *chromeURLString = [NSString stringWithFormat:
                                 @"%@//x-callback-url/open/?x-source=%@&x-success=%@&url=%@",
                                 kGoogleChromeCallbackScheme,
                                 encodeByAddingPercentEscapes([bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]),
                                 encodeByAddingPercentEscapes(callbackURL.absoluteString),
                                 encodeByAddingPercentEscapes(url.absoluteString)];

    NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
    [[UIApplication sharedApplication] openURL:chromeURL];
}

static NSString * encodeByAddingPercentEscapes(NSString *input)
{
    NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                        kCFAllocatorDefault,
                                                        (CFStringRef)input,
                                                        NULL,
                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                        kCFStringEncodingUTF8));
    return encodedValue;
}


+ (BOOL)isChromeInstalled {
    NSURL *simpleURL = [NSURL URLWithString:kGoogleChromeHTTPScheme];
    NSURL *callbackURL = [NSURL URLWithString:kGoogleChromeCallbackScheme];
    return  [[UIApplication sharedApplication] canOpenURL:simpleURL] || [[UIApplication sharedApplication] canOpenURL:callbackURL];
}

@end
