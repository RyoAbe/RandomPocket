//
//  UIGetPocketsOperation.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/08/29.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIPocketList;

@interface GetPocketsOperation : NSObject
- (id)initWithSuccessBlock:(void(^)(UIPocketList* pocketList))successBlock errorBlock:(void (^)(NSError *error))errorBlock;
- (void)request;
@end
