//
//  UIGetPocketsOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/29.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "GetPocketsOperation.h"

@interface GetPocketsOperation()
@property (nonatomic) NSMutableArray *response;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation GetPocketsOperation

- (id)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return self;
}

- (void)request
{
    [[PocketAPI sharedAPI] callAPIMethod:@"get"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:@{@"detailType": @"complete", @"count": @(20)}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     if(error){
                                         self.errorHandler(error);
                                         return;
                                     }
                                     [self saveWithResponse:response];
                                 }];
}

- (void)saveWithResponse:(NSDictionary*)response;
{
    for (NSString *key in response[@"list"]) {
        NSDictionary *data = response[@"list"][key];

        NSString* itemID = data[@"item_id"];
        CPocket *cPocket = [self.managedObjectContext pocketWithItemID:itemID];
        if(!cPocket){
            cPocket = [self.managedObjectContext createEntity:@"CPocket"];
        }
        cPocket.title = data[@"resolved_title"];
        cPocket.url = data[@"resolved_url"];
        cPocket.itemID = data[@"item_id"];
        cPocket.status = [data[@"status"] integerValue];
        cPocket.sortID = [data[@"sort_id"] integerValue];
        cPocket.timeAdded = [NSDate dateWithTimeIntervalSince1970:[data[@"time_added"] integerValue]];
        cPocket.favorite = [data[@"favorite"] integerValue];

        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            self.errorHandler(error);
            return;
        }
    }
    self.completionHandler();
}

@end