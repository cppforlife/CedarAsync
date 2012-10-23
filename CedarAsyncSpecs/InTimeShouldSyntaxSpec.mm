#import "CedarAsync.h"
#import "AsyncAction.h"
#import "ExpectCallLength.h"
#import "ExpectFailureWithMessage.h"

SPEC_BEGIN(InTimeSyntaxSpec)

using namespace Cedar::Matchers;

describe(@"in_time syntax", ^{
    __block AsyncAction *action;

    beforeEach(^{
        action = [[[AsyncAction alloc] init] autorelease];
    });

    describe(@"positive matching", ^{
        context(@"when actual initially matches expected value", ^{
            it(@"reports a pass", ^{
                [action start];
                expectShortCallLength(^{
                    in_time(action.value) should equal(@"FROM");
                });
            });
        });

        context(@"when actual does not initially match expected value", ^{
            context(@"when actual eventually matches expected value", ^{
                it(@"reports a pass", ^{
                    [action start];
                    expectLongCallLength(^{
                        in_time(action.value) should equal(@"TO");
                    });
                });
            });

            context(@"when actual does not eventually match expected value", ^{
                it(@"reports a failure", ^{
                    [action start];
                    expectLongCallLength(^{
                        expectFailureWithMessage(@"Expected <TO> to equal <OTHER>", ^{
                            in_time(action.value) should equal(@"OTHER");
                        });
                    });
                });
            });
        });
    });

    describe(@"negative matching", ^{
        context(@"when actual does not initially match expected value", ^{
            it(@"reports a pass", ^{
                [action start];
                expectShortCallLength(^{
                    in_time(action.value) should_not equal(@"OTHER");
                });
            });
        });

        context(@"when actual initially matches expected value", ^{
            context(@"when actual eventually does not match expected value", ^{
                it(@"reports a pass", ^{
                    [action start];
                    expectLongCallLength(^{
                        in_time(action.value) should_not equal(@"FROM");
                    });
                });
            });

            context(@"when actual eventually matches expected value", ^{
                it(@"reports a failure", ^{
                    action.to = @"FROM";
                    [action start];

                    expectLongCallLength(^{
                        expectFailureWithMessage(@"Expected <FROM> to not equal <FROM>", ^{
                            in_time(action.value) should_not equal(@"FROM");
                        });
                    });
                });
            });
        });
    });
});

SPEC_END
