//
//  ArchivePocketOperation.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/12.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomPocketCore.h"

typedef NS_ENUM(NSUInteger, ActionToPocketType) {
    ActionToPocketType_Readd = 0,
    ActionToPocketType_Archive,
    ActionToPocketType_Delete,
    ActionToPocketType_Favorite,
    ActionToPocketType_Unfavorite,
};

@interface ActionToPocketOperation : NetworkAsyncOperation
- (id)initWithItemID:(NSString*)itemID actionType:(ActionToPocketType)actionType;
@end
