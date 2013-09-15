//
//  ArchivePocketOperation.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/12.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "AsyncOperation.h"
#import "RandomPocketCore.h"

typedef NS_ENUM(NSUInteger, RequestActionToPocketType) {
    RequestActionToPocketType_Readd = 0,
    RequestActionToPocketType_Archive,
    RequestActionToPocketType_Delete,
    RequestActionToPocketType_Favorite,
    RequestActionToPocketType_Unfavorite,
};

@interface RequestActionToPocketOperation : AsyncOperation
- (id)initWithPocketID:(NSManagedObjectID*)pocketID actionType:(RequestActionToPocketType)actionType;
- (void)request;
@end
