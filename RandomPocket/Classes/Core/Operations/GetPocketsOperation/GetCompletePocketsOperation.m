//
//  GetCompletePocketsOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/03/22.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "GetCompletePocketsOperation.h"
#import "RandomPocketCore.h"

@implementation GetCompletePocketsOperation

- (void)dispatch
{
    RATime *time = [RATime start];
    [[PocketAPI sharedAPI] callAPIMethod:@"get"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:@{@"detailType": @"complete"}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     [time stop];
                                     __weak GetCompletePocketsOperation *weakSelf = self;
                                     
                                     RATime *time = [RATime start];
                                     [self setDispatchHandler:^id{
                                         id ret = [weakSelf saveWithResponse:response];
                                         [time stop];
                                         return ret;
                                     }];
                                     [super dispatch];
                                 }];
}

- (id)saveWithResponse:(NSDictionary*)response
{
    for (NSString *key in response[@"list"]) {
        NSDictionary *data = response[@"list"][key];
        [self saveWithData:data];
    }
    NSError *error = nil;
    if (![NSManagedObjectContext save:&error]) {
        return error;
    }
    return nil;
}

- (void)saveWithData:(NSDictionary*)data
{
    NSManagedObjectContext *moc = [NSManagedObjectContext contextForCurrentThread];
    NSString* itemID = data[@"item_id"];
    CPocket *cPocket = [moc pocketWithItemID:itemID];
    if(!cPocket){
        cPocket = [moc createEntity:@"CPocket"];
    }

    NSDictionary *image = data[@"image"];
    cPocket.imageUrl = image[@"src"];
}

@end
