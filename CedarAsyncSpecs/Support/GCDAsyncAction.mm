//
//  GCDAsyncAction.m
//  CedarAsync
//
//  Created by Paul Taykalo on 3/18/13.
//
//

#import "GCDAsyncAction.h"

@implementation GCDAsyncAction

- (void)start {
    self.value = self.from;
    double delayInSeconds = self.delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self end];
    });
}

@end
