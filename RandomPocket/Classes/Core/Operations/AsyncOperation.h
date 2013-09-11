//
//  AsyncOperation.h
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/02.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AsyncOperation : NSObject
- (id)initWithExecuteHandler:(void(^)())executeHandler
           completionHandler:(void(^)(id result))completionHandler
                errorHandler:(void(^)(NSError *error))errorHandler;
- (void)execute;
@property (nonatomic, copy) void (^executeHandler)();
@property (nonatomic, copy) void (^completionHandler)();
@property (nonatomic, copy) void (^errorHandler)(NSError *error);
@end
