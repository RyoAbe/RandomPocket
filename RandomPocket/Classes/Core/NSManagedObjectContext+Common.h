//
//  NSManagedObjectContext+Common.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/11/23.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Common)
+ (NSManagedObjectContext *)contextForCurrentThread;
+ (NSManagedObjectContext *)contextForMainThread;
+ (BOOL)save:(NSError **)error;
@end
