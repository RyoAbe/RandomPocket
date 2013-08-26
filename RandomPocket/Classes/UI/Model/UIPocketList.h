//
//  UIPocketList.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/26.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIPocketList;
@class UIPocket;

typedef enum UIPocketListChangeType_ {
    UIPocketListChangeType_Insert = 1,
    UIPocketListChangeType_Delete = 2,
    UIPocketListChangeType_Move = 3,
    UIPocketListChangeType_Update = 4,
} UIPocketListChangeType;


@interface UIPocketList : NSObject
- (id)initWithSuccessBlock:(void(^)())successBlock errorBlock:(void(^)())errorBlock;
- (void)request;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (UIPocket*)objectAtIndex:(NSUInteger)index;
- (UIPocket*)objectAtIndexPath:(NSIndexPath*)indexPath;

@end
