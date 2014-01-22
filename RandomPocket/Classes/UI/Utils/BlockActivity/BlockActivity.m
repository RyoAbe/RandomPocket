//
//  BlockActivity.m
//  Created by Ryu Iwasaki on 2013/10/04.
//  Copyright (c) 2013年 Ryu Iwasaki. All rights reserved.
//

#import "BlockActivity.h"

@implementation BlockActivity


- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    /*
    Please be controlled, as in this example, if you want to control the type of the corresponding.
    
	for (id activityItem in activityItems) {
        
        if ([activityItem isKindOfClass:[NSString class]]){
            return YES;
        }
    }
    */
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems{
    
}


@end
