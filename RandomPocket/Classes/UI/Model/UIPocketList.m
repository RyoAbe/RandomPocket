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
@end

static NSInteger const NumberOfSections = 1;

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
                               arguments:@{@"complete": @"detailType", @"count": @(30)}
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
    
    if(!error && response.count != 0){
        self.successBlock();
        return ;
    }
    self.errorBlock();
}

- (NSInteger)numberOfSections
{
    return NumberOfSections;
}

- (NSUInteger)numberOfItems
{
    return self.response.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.response.count;
}

- (NSIndexPath*)indexPathForObject:(UIPocket*)pocket
{
    NSInteger index = [self.response indexOfObject:pocket];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:NumberOfSections];
    return indexPath;
}

- (NSInteger)indexForObject:(UIPocket*)pocket
{
    NSInteger index = [self.response indexOfObject:pocket];
    return index;
}

- (UIPocket*)objectAtIndex:(NSUInteger)index
{
    return self.response[index];
}

- (UIPocket*)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return self.response[indexPath.row];
}

@end
