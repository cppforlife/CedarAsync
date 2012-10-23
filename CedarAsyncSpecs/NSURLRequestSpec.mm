#import "CedarAsync.h"
#import "HTTPClient.h"

SPEC_BEGIN(NSURLRequestSpec)

using namespace Cedar::Matchers;

describe(@"Works with NSURLRequest", ^{
    __block HTTPClient *client;

    beforeEach(^{
        client = [[[HTTPClient alloc] init] autorelease];
    });

    it(@"fetches google's homepage", ^{
        [client fetchURLString:@"http://google.com"];
        client.lastResponse should be_nil;

        with_timeout(4, ^{
            in_time(client.lastResponse) should contain(@"Google");
        });
    });
});

SPEC_END
