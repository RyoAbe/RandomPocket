//
//  ArchivePocketOperation.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/12.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "AsyncOperation.h"
#import "RandomPocketCore.h"

@interface ArchivePocketOperation : AsyncOperation
- (id)initWithPocketID:(NSManagedObjectID*)pocketID toArchive:(BOOL)toArchive;
- (void)archive;
@end
