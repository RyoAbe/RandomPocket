//
//  ArchivePocketOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/12.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "ActionToPocketOperation.h"
#import "RandomPocketUI.h"

@interface ActionToPocketOperation()
@property (nonatomic) ActionToPocketType actionType;
@property (nonatomic) NSString *itemID;
@end

@implementation ActionToPocketOperation

- (id)initWithItemID:(NSString*)itemID actionType:(ActionToPocketType)actionType
{
    self = [super init];
    if (self) {
        self.itemID = itemID;
        self.actionType = actionType;
    }
    return self;
}

- (void)dispatch
{
    NSString *arguments = [NSString stringWithFormat:@"[{\"action\":\"%@\",\"item_id\" : \"%@\"}]", self.actionStr, self.itemID];
    [[PocketAPI sharedAPI] callAPIMethod:@"send"
                          withHTTPMethod:PocketAPIHTTPMethodGET
                               arguments:@{@"actions":arguments}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     if(error){
                                         self.errorHandler(error);
                                         return;
                                     }                                     
                                     __weak ActionToPocketOperation *weakSelf = self;
                                     [self setDispatchHandler:^id{
                                         if(error) return error;
                                         return [weakSelf saveWithResponse:response];
                                     }];
                                     [super dispatch];
                                 }];
}

- (id)saveWithResponse:(NSDictionary*)response
{
    CPocket *cPocket = [[NSManagedObjectContext contextForCurrentThread] pocketWithItemID:self.itemID];
    cPocket.status = [response[@"status"] integerValue];
    NSError *error = nil;
    if (![NSManagedObjectContext save:&error]) {
        NSAssert(NO, error.userInfo.description);
        return error;
    }
    return nil;
}

#pragma mark -

- (NSString*)actionStr
{
    NSString *action = nil;
    switch (self.actionType) {
        case ActionToPocketType_Readd:
            action = @"readd";
            break;
        case ActionToPocketType_Archive:
            action = @"archive";
            break;
        case ActionToPocketType_Delete:
            action = @"delete";
            break;
        case ActionToPocketType_Favorite:
            action = @"favorite";
            break;
        case ActionToPocketType_Unfavorite:
            action = @"unfavorite";
            break;
        default:
            NSAssert(NO, nil);
            break;
    }
    return action;
}

@end
