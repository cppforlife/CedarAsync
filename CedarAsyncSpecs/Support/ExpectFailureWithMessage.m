#import "ExpectFailureWithMessage.h"

void expectFailureWithMessage(NSString *message, void(^block)(void)) {
    @try {
        block();
    }
    @catch (NSException *x) {
        if (![message isEqualToString:x.reason]) {
            fail([NSString stringWithFormat:@"Expected failure message: <%@> but received failure message <%@>", message, x.reason]);
        }
        return;
    }
    fail(@"Expectation should have failed.");
}
