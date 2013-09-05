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

- (id)initWithSuccessBlock:(void(^)(UIPocketList* pocketList))successBlock errorBlock:(void (^)(NSError *error))errorBlock
{
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
        self.errorBlock = errorBlock;
        self.response = [NSMutableArray new];
        self.pocketList = [[UIPocketList alloc] init];
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
        cPocket.url = data[@"resolved_url"];
        cPocket.title = data[@"resolved_title"];
        SavePocketOperation *op = [[SavePocketOperation alloc] initWithCPocket:cPocket];
        [op save];
        
        UIPocket *pocket = [[UIPocket alloc] initWithData:data];
        [self.response addObject:pocket];
    }
    self.pocketList.response = self.response;
    
    if(!error && response.count != 0){
        self.successBlock(self.pocketList);
        return ;
    }
    self.errorBlock(error);
}

@end
