//
//  UIPocketList.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "UIPocketList.h"
#import "RandomPocketUI.h"

@interface UIPocketList()
@property (nonatomic, copy) void (^successBlock)();
@property (nonatomic, copy) void (^errorBlock)();
@property (nonatomic) NSMutableArray *response;
@end

@implementation UIPocketList

- (id)initWithSuccessBlock:(void(^)())successBlock errorBlock:(void(^)())errorBlock
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
                               arguments:@{@"complete": @"detailType", @"count": @(10)}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     [self handlerWithResponse:response error:error];
                                 }];
}

- (void)handlerWithResponse:(NSDictionary*)response error:(NSError*)error;
{
    for (NSString *key in response[@"list"]) {
        [self.response addObject:response[@"list"][key]];
    }
    
    if(!error){
        self.successBlock();
        return ;
    }
    self.errorBlock();
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return self.response.count;
}

- (UIPocket*)objectAtIndex:(NSUInteger)index
{
    UIPocket *pocket = [[UIPocket alloc] initWithData:self.response[index]];
    return pocket;
}

- (UIPocket*)objectAtIndexPath:(NSIndexPath*)indexPath
{
    UIPocket *pocket = [[UIPocket alloc] initWithData:self.response[indexPath.row]];
    return pocket;
}

@end
