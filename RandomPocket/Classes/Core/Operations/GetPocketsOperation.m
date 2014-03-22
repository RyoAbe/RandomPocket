//
//  UIGetPocketsOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/29.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "GetPocketsOperation.h"

@interface GetPocketsOperation()
@property (nonatomic) NSDate *updateDate;
@end

@implementation GetPocketsOperation

- (void)dispatch
{
    RATime *time = [RATime start];
    [[PocketAPI sharedAPI] callAPIMethod:@"get"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:@{
                                           @"detailType": @"simple"
//                                           @"detailType": @"complete"
//                                           , @"status": @"all"
//                                           , @"count": @3
                                           }
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error) {
                                     [time stop];
                                     __weak GetPocketsOperation *weakSelf = self;

                                     RATime *time = [RATime start];
                                     [self setDispatchHandler:^id{
                                         id ret = [weakSelf saveWithResponse:response];
                                         [time stop];
                                         return ret;
                                     }];
                                     [super dispatch];
                                 }];
}

- (id)saveWithResponse:(NSDictionary*)response
{
    self.updateDate = [NSDate date];
    for (NSString *key in response[@"list"]) {
        NSDictionary *data = response[@"list"][key];
        [self saveWithData:data];
    }
    NSError *error = nil;
    // updateDateが更新されていないものをアーカイブ化
    [self toArchiveNoUpdatePocket:&error];

    if (![NSManagedObjectContext save:&error]) {
        return error;
    }
    return nil;
}

- (void)toArchiveNoUpdatePocket:(NSError**)error
{
    NSManagedObjectContext *moc = [NSManagedObjectContext contextForCurrentThread];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CPocket"];

    // updateDateが更新されていないものをアーカイブ or 削除されているとする
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"updateDate != %@", self.updateDate];

    NSArray *deletedPockets = [moc executeFetchRequest:fetchRequest error:nil];
    for (CPocket *pocket in deletedPockets) {
        // 削除されている可能性もあるが、全件取得はレスポンスに時間がかかるためここではアーカイブのステータスとする
        pocket.status = PocketStatus_Archived;
    }
}

- (void)saveWithData:(NSDictionary*)data
{
    NSManagedObjectContext *moc = [NSManagedObjectContext contextForCurrentThread];
    NSString* itemID = data[@"item_id"];
    CPocket *cPocket = [moc pocketWithItemID:itemID];
    if(!cPocket){
        cPocket = [moc createEntity:@"CPocket"];
    }
    NSString *url = data[@"resolved_url"];
    if(!url || url.length == 0){
        url = data[@"given_url"];
    }
    cPocket.url = url;
    
    NSString *title = data[@"resolved_title"];
    if(!title || title.length == 0){
        title = data[@"given_title"];
        if(!title || title.length == 0){
            title = cPocket.url;
        }
    }
    cPocket.title = title;

    cPocket.itemID = data[@"item_id"];
    cPocket.status = [data[@"status"] integerValue];
    cPocket.sortID = [data[@"sort_id"] integerValue];
    cPocket.timeAdded = [NSDate dateWithTimeIntervalSince1970:[data[@"time_added"] integerValue]];
    cPocket.favorite = [data[@"favorite"] integerValue];
    cPocket.excerpt = data[@"excerpt"];
    cPocket.hasImage = [data[@"has_image"] integerValue];
    cPocket.updateDate = self.updateDate;
}

@end
