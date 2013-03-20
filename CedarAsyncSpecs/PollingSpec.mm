#import "CedarAsync.h"
#import "AsyncAction.h"
#import "ExpectFailureWithMessage.h"

SPEC_BEGIN(PollingSpec)

using namespace Cedar::Matchers;

describe(@"Polling", ^{
    NSTimeInterval diff = CedarAsync::Timing::default_poll / 2;

    __block NSTimerAsyncAction *action;

    beforeEach(^{
        action = [[[NSTimerAsyncAction alloc] init] autorelease];
    });

    it(@"uses default poll", ^{
        Timing::current_poll should equal(Timing::default_poll);
        Timing::current_poll should be_less_than(Timing::current_timeout);
        Timing::current_poll should be_greater_than(0);
    });

    describe(@"with custom poll", ^{
        beforeEach(^{
            Timing::current_poll += diff;
        });

        context(@"when matching succeeds", ^{
            void (^match)(void) = ^{
                [action start];
                in_time(action.value) should equal(@"TO");
            };

            context(@"when poll is greater than delay", ^{
                it(@"makes a match in the beginning and right after delay", ^{
                    Timing::current_poll = action.delay + diff;
                    match();
                    action.valueCallCount should equal(2);
                    action.valueCallCountAfterChange should equal(1);
                });
            });

            context(@"when poll is same as delay", ^{
                it(@"makes a match in the beginning and exactly at the delay", ^{
                    Timing::current_poll = action.delay;
                    match();
                    action.valueCallCount should equal(2);
                    action.valueCallCountAfterChange should equal(1);
                });
            });

            context(@"when poll is less than delay", ^{
                it(@"makes a match in the beginning, before delay and right after delay", ^{
                    Timing::current_poll = action.delay - diff;
                    match();
                    action.valueCallCount should equal(3);
                    action.valueCallCountAfterChange should equal(1);
                });
            });
        });

        context(@"when matching does not succeed", ^{
            void (^match)(void) = ^{
                [action start];
                @try { in_time(action.value) should equal(@"OTHER"); } @catch(id x) {}
            };

            context(@"when poll is greater than timeout", ^{
                it(@"makes a match in the beginning and one at the end", ^{
                    Timing::current_poll = Timing::current_timeout + diff;
                    match();
                    action.valueCallCount should equal(2);
                });
            });

            context(@"when poll is same as timeout", ^{
                it(@"makes a match in the beginning and one at the end", ^{
                    Timing::current_poll = Timing::current_timeout;
                    match();
                    action.valueCallCount should equal(2);
                });
            });

            context(@"when poll is less than timeout", ^{
                it(@"makes a match in the beginning, in the middle and one at the end", ^{
                    Timing::current_poll = Timing::current_timeout - diff;
                    match();
                    action.valueCallCount should equal(3);
                });
            });
        });
    });
});

SPEC_END
