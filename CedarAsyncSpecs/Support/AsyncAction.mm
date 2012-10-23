#import "AsyncAction.h"
#import "Timing.h"

@interface AsyncAction ()
@property (nonatomic, assign) int valueCallCountAtChange;
@end

@implementation AsyncAction
@synthesize
    delay = delay_,
    value = value_,
    from = from_,
    to = to_,
    valueCallCount = valueCallCount_,
    valueCallCountAtChange = valueCallCountAtChange_;

- (id)init {
    if (self = [super init]) {
        self.delay = CedarAsync::Timing::default_timeout / 2;
        self.from = @"FROM";
        self.to = @"TO";
    }
    return self;
}

- (void)dealloc {
    self.from = nil;
    self.to = nil;
    [super dealloc];
}

- (void)start {
    self.value = self.from;
    [self performSelector:@selector(end) withObject:nil afterDelay:self.delay];
}

- (void)end {
    self.valueCallCountAtChange = self.valueCallCount;
    self.value = self.to;
}

- (NSString *)value {
    self.valueCallCount += 1;
    return value_;
}

- (int)valueCallCountAfterChange {
    if (self.valueCallCountAtChange > 0) {
        return self.valueCallCount - self.valueCallCountAtChange;
    }
    return 0;
}
@end
