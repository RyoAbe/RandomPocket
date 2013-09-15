//
//  ArchivePocketOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/12.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "RequestActionToPocketOperation.h"
#import "RandomPocketUI.h"

@interface RequestActionToPocketOperation()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectID *pocketID;
@property (nonatomic) CPocket *cPocket;
@property (nonatomic) RequestActionToPocketType actionType;
@end

@implementation RequestActionToPocketOperation

- (id)initWithPocketID:(NSManagedObjectID*)pocketID actionType:(RequestActionToPocketType)actionType
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
    NSString *arguments = [NSString stringWithFormat:@"[{\"action\":\"%@\",\"item_id\" : \"%@\"}]", self.actionStr, self.cPocket.itemId];

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
        case RequestActionToPocketType_Readd:
            action = @"readd";
            break;
        case RequestActionToPocketType_Archive:
            action = @"archive";
            break;
        case RequestActionToPocketType_Delete:
            action = @"delete";
            break;
        case RequestActionToPocketType_Favorite:
            action = @"favorite";
            break;
        case RequestActionToPocketType_Unfavorite:
            action = @"unfavorite";
            break;
        default:
            NSAssert(NO, nil);
            break;
    }
    return action;
}

- (PocketStatus)pocketStatus:(NSString*)statusStr
{
    if([statusStr isEqualToString:@"0"]){
        return PocketStatus_Unread;
    }else if ([statusStr isEqualToString:@"1"]){
        return PocketStatus_Archived;
    }else if ([statusStr isEqualToString:@"2"]){
        return PocketStatus_Deleted;
    }else{
#warning NSAssert拡張ラッパー作成
        NSAssert(NO, nil);
    }
}

@end
