//
//  SavePocketOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/02.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "SavePocketOperation.h"
#import <CoreData/CoreData.h>
#import "RandomPocketUI.h"

@interface SavePocketOperation()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation SavePocketOperation

- (id)initWithCPocket:(CPocket*)cPcoket
{
    self = [super init];
    if (self) {
        self.managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    }
    return self;
}

- (void)save
{    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
#warning エラー処理
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

@end
