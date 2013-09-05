//
//  CPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/03.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CPocket : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSData *entryDate;
@property (nonatomic) BOOL isArchive;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

@end
