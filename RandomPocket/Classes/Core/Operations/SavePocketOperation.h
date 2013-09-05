//
//  SavePocketOperation.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/02.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPocket;

@interface SavePocketOperation : NSObject
- (id)initWithCPocket:(CPocket*)cPcoket;
- (void)save;
@end
