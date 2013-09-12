//
//  ArchivePocketOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/12.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "ArchivePocketOperation.h"
#import "RandomPocketUI.h"

@interface ArchivePocketOperation()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectID *pocketID;
@property (nonatomic) CPocket *cPocket;
@property (nonatomic) BOOL toArchive;
@end

@implementation ArchivePocketOperation

- (id)initWithPocketID:(NSManagedObjectID*)pocketID toArchive:(BOOL)toArchive
{
    self = [super init];
    if (self) {
        self.managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        self.pocketID = pocketID;
        self.toArchive = toArchive;
    }
    return self;
}

- (void)archive
{
    self.cPocket = [self.managedObjectContext entityWithID:self.pocketID];

    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    [[PocketAPI sharedAPI] callAPIMethod:@"archive"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:@{@"item_id":self.cPocket.itemId, @"time":timestamp}
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
    self.cPocket.archive = self.toArchive;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        self.errorHandler(error);
        return;
    }
    self.completionHandler();
}

@end
