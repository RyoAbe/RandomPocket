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
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectID *pocketID;
@property (nonatomic) CPocket *cPocket;
@property (nonatomic) ActionToPocketType actionType;
@end

@implementation ActionToPocketOperation

- (id)initWithPocketID:(NSManagedObjectID*)pocketID actionType:(ActionToPocketType)actionType
{
    self = [super init];
    if (self) {
        self.managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        self.pocketID = pocketID;
        self.actionType = actionType;
    }
    return self;
}

- (void)dispatch
{
    self.cPocket = [self.managedObjectContext entityWithID:self.pocketID];
    NSString *arguments = [NSString stringWithFormat:@"[{\"action\":\"%@\",\"item_id\" : \"%@\"}]", self.actionStr, self.cPocket.itemID];
    [[PocketAPI sharedAPI] callAPIMethod:@"send"
                          withHTTPMethod:PocketAPIHTTPMethodGET
                               arguments:@{@"actions":arguments}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     
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
    self.cPocket.status = [response[@"status"] integerValue];
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
