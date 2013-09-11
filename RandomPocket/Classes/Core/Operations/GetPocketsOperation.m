//
//  UIGetPocketsOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/29.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "GetPocketsOperation.h"
#import "RandomPocketUI.h"
#import "UIPocketList.h"

@interface GetPocketsOperation()
@property (nonatomic) NSMutableArray *response;
@property (nonatomic) UIPocketList *pocketList;
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
                               arguments:@{@"complete": @"detailType", @"count": @(20)}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     [self handlerWithResponse:response error:error];
                                 }];
}

- (void)handlerWithResponse:(NSDictionary*)response error:(NSError*)error;
{
    if(error){
        self.errorHandler(error);
        return;
    }
    
    for (NSString *key in response[@"list"]) {
        NSDictionary *data = response[@"list"][key];
        CPocket *cPocket = [self.managedObjectContext createEntity:@"CPocket"];
        cPocket.title = data[@"resolved_title"];
        cPocket.url = data[@"resolved_url"];
    }

    error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        self.errorHandler(error);
        return;
    }
    self.completionHandler();
}

@end
