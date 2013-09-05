//
//  NSManagedObjectContext+RandomPocket.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/05.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (RandomPocket)
- (id)createEntity:(NSString *)name;
@end
