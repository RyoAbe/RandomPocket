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
@property (nonatomic, copy) void (^successBlock)();
@property (nonatomic, copy) void (^errorBlock)();
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
    for (NSString *key in response[@"list"]) {
        NSDictionary *data = response[@"list"][key];
        
        CPocket *cPocket = [self.managedObjectContext createEntity:@"CPocket"];
        cPocket.title = data[@"resolved_title"];
        cPocket.url = data[@"resolved_url"];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
#warning TODO: エラー処理
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
#warning TODO: delegate経由で進捗状況をViewに伝える（＋エラー処理）
}

@end
