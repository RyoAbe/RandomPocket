//
//  UIGetPocketsOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/29.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIGetPocketsOperation.h"
#import "RandomPocketUI.h"
#import "UIPocketList.h"

@interface UIGetPocketsOperation()
@property (nonatomic, copy) void (^successBlock)();
@property (nonatomic, copy) void (^errorBlock)();
@property (nonatomic) NSMutableArray *response;
@end

@implementation UIGetPocketsOperation

- (id)initWithSuccessBlock:(void(^)(UIPocketList* pocketList))successBlock errorBlock:(void (^)(NSError *error))errorBlock
{
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
        self.errorBlock = errorBlock;
        self.response = [NSMutableArray new];

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
        UIPocket *pocket = [[UIPocket alloc] initWithData:data];
        [self.response addObject:pocket];
    }
    UIPocketList *pocketList = [[UIPocketList alloc] init];
    pocketList.response = self.response;
    
    if(!error && response.count != 0){
        self.successBlock(pocketList);
        return ;
    }
    self.errorBlock(error);
}

@end
