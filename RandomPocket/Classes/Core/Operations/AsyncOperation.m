//
//  AsyncOperation.m
//  RandomPocket
//
//  Created by RyoAbe on 2013/09/02.
//  Copyright (c) 2013年 RyoAbe. All rights reserved.
//

#import "AsyncOperation.h"

@implementation AsyncOperation

- (id)initWithExecuteHandler:(void(^)())executeHandler
           completionHandler:(void(^)(id result))completionHandler
                errorHandler:(void(^)(NSError *error))errorHandler
{
    self = [super init];
    if (self) {
        self.completionHandler = completionHandler;
        self.errorHandler = errorHandler;
    }
    return self;
}

- (void)dispatch
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        id result = self.dispatchHandler();
        dispatch_async(dispatch_get_main_queue(), ^{
            if([result isKindOfClass:[NSError class]]){
                NSAssert(NO, ((NSError*)result).localizedDescription);
                self.errorHandler((NSError*)result);
            }else{
                self.completionHandler(result);
            }
        });
    });
}

@end
