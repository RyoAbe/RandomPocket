//
//  CPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/12.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CPocket : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSDate * entryDate;
@property (nonatomic) BOOL archive;
@property (nonatomic) BOOL favorite;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * itemId;

@end
