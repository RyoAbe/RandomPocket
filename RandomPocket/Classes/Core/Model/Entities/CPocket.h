//
//  CPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/10/31.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, PocketStatus) {
    PocketStatus_Unread = 0,
    PocketStatus_Archived,
    PocketStatus_Deleted,
};

@interface CPocket : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) BOOL favorite;
@property (nonatomic, retain) NSString * itemID;
@property (nonatomic) int16_t sortID;
@property (nonatomic) int16_t status;
@property (nonatomic) NSDate * timeAdded;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * excerpt;

@end
