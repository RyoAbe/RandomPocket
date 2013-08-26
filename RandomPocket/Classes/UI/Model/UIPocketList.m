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
@property (nonatomic) NSDictionary *response;
@end

@implementation UIPocketList

- (id)initWithSuccessBlock:(void(^)())successBlock errorBlock:(void(^)())errorBlock
{
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
        self.errorBlock = errorBlock;
    }
    return self;
}

- (void)request
{

    [[PocketAPI sharedAPI] callAPIMethod:@"get"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:@{@"simple": @"detailType"}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     [self handlerWithResponse:response error:error];
                                 }];
}

- (void)handlerWithResponse:(NSDictionary*)response error:(NSError*)error;
{
    self.response = response[@"list"];
    
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
    UIPocket *pocket = [UIPocket new];
    pocket.url = self.response[@"62944243"][@"given_url"];
    return pocket;
}

- (UIPocket*)objectAtIndexPath:(NSIndexPath*)indexPath
{
    UIPocket *pocket = [UIPocket new];
    pocket.url = self.response[@"62944243"][@"given_url"];
    return pocket;
}

@end
