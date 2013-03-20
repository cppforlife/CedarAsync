#import "CedarAsync.h"
#import "AsyncAction.h"
#import "ExpectFailureWithMessage.h"

SPEC_BEGIN(TimeoutSpec)

using namespace Cedar::Matchers;

describe(@"Timeout", ^{
    NSTimeInterval diff = CedarAsync::Timing::default_timeout / 2;

    __block AsyncAction *action;

    beforeEach(^{
        action = [[[NSTimerAsyncAction alloc] init] autorelease];
    });

    it(@"uses default timeout", ^{
        Timing::current_timeout should equal(Timing::default_timeout);
        Timing::current_timeout should be_greater_than(0);
    });

    describe(@"with custom global timeout", ^{
        beforeEach(^{
            Timing::current_timeout += diff;
        });

        context(@"when matching succeeds within timeout", ^{
            void  (^match)(void) = ^{
                [action start];
                in_time(action.value) should equal(@"TO");
            };

            context(@"when delay is less than timeout", ^{
                it(@"reports a pass", ^{
                    action.delay = Timing::current_timeout - diff;
                    match();
                    action.valueCallCountAfterChange should equal(1);
                });
            });

            context(@"when delay is same as timeout", ^{
                it(@"reports a pass", ^{
                    action.delay = Timing::current_timeout;
                    match();
                    action.valueCallCountAfterChange should equal(1);
                });
            });
        });

        context(@"when matching fails within timeout", ^{
            it(@"reports a failure", ^{
                action.delay = Timing::current_timeout + diff;
                [action start];
                expectFailureWithMessage(@"Expected <FROM> to equal <TO>", ^{
                    in_time(action.value) should equal(@"TO");
                });
            });
        });
    });

    describe(@"with_timeout", ^{
        it(@"temporarily changes timeout", ^{
            NSTimeInterval originalTimeout = Timing::current_timeout;
            NSTimeInterval customTimeout = originalTimeout + diff;

            with_timeout(customTimeout, ^{
                Timing::current_timeout should equal(customTimeout);
            });
            Timing::current_timeout should equal(originalTimeout);
        });
    });
});

SPEC_END
