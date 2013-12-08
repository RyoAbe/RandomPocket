//
//  UIGetPocketsOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/29.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "GetPocketsOperation.h"

@implementation GetPocketsOperation

- (void)dispatch
{
    [[PocketAPI sharedAPI] callAPIMethod:@"get"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:@{@"detailType": @"complete", @"count": @3}
//                               arguments:@{@"detailType": @"complete"}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     NSAssert(!error, error.localizedDescription);
                                     __weak GetPocketsOperation *weakSelf = self;
                                     [self setDispatchHandler:^id{
                                         return [weakSelf saveWithResponse:response];
                                     }];
                                     [super dispatch];
                                 }];
}

- (id)saveWithResponse:(NSDictionary*)response;
{
    NSManagedObjectContext *moc = [NSManagedObjectContext contextForCurrentThread];
    for (NSString *key in response[@"list"]) {
        NSDictionary *data = response[@"list"][key];

        NSString* itemID = data[@"item_id"];
        CPocket *cPocket = [moc pocketWithItemID:itemID];
        if(!cPocket){
            cPocket = [moc createEntity:@"CPocket"];
        }
        cPocket.title = data[@"given_title"];
        cPocket.url = data[@"resolved_url"];
        cPocket.itemID = data[@"item_id"];
        cPocket.status = [data[@"status"] integerValue];
        cPocket.sortID = [data[@"sort_id"] integerValue];
        cPocket.timeAdded = [NSDate dateWithTimeIntervalSince1970:[data[@"time_added"] integerValue]];
        cPocket.favorite = [data[@"favorite"] integerValue];
        cPocket.excerpt = data[@"excerpt"];
        NSDictionary *image = data[@"image"];
        cPocket.imageUrl = image[@"src"];
    }
    NSError *error = nil;
    if (![NSManagedObjectContext save:&error]) {
        return error;
    }
    
    return nil;
}

@end
