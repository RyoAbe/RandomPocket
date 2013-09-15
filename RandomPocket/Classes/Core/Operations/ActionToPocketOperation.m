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

- (void)request
{
    self.cPocket = [self.managedObjectContext entityWithID:self.pocketID];

#warning JBJson入れる
    NSString *arguments = [NSString stringWithFormat:@"[{\"action\":\"%@\",\"item_id\" : \"%@\"}]", self.actionStr, self.cPocket.itemID];

    [[PocketAPI sharedAPI] callAPIMethod:@"send"
                          withHTTPMethod:PocketAPIHTTPMethodGET
                               arguments:@{@"actions":arguments}
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     if(error){
                                         self.errorHandler(error);
                                         return;
                                     }
                                     [self saveWithResponse:response];
                                 }];
}

- (void)saveWithResponse:(NSDictionary*)response
{
    self.cPocket.status = [self pocketStatus:response[@"status"]];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        self.errorHandler(error);
        return;
    }
    self.completionHandler();
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
#warning imple NSAssert Ex
            NSAssert(NO, nil);
            break;
    }
    return action;
}

- (PocketStatus)pocketStatus:(NSString*)statusStr
{
    if ([statusStr isEqualToString:@"1"]){
        return PocketStatus_Archived;
    }else if ([statusStr isEqualToString:@"2"]){
        return PocketStatus_Deleted;
    }
    return PocketStatus_Unread;
}

@end
