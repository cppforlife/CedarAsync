#import <Foundation/Foundation.h>

@interface AsyncAction : NSObject
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, retain) NSString *value, *from, *to;
@property (nonatomic, assign) int valueCallCount;

- (void)start;
- (int)valueCallCountAfterChange;
- (void)end;
@end

@interface NSTimerAsyncAction : AsyncAction
@end

@interface GCDAsyncAction : AsyncAction
@end
