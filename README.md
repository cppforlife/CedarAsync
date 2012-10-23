CedarAsync lets you use [Cedar](http://github.com/pivotal/cedar) matchers to 
test asynchronous code. This becomes useful when writing intergration tests 
rather than plain unit tests. (CedarAsync only supports Cedar's should syntax.)

Instead of

    client.lastResponse should contain(@"Google");

use

    in_time(client.lastResponse) should contain(@"Google");

to force `contain` matcher check `client.lastResponse` multiple times until 
it succeeds or times out.

### Example

    #import "CedarAsync.h"
    #import "HTTPClient.h"
    
    SPEC_BEGIN(HTTPClientSpec)
    
    using namespace Cedar::Matchers;
    
    describe(@"HTTPClient", ^{
        __block HTTPClient *client;
        
        beforeEach(^{
            client = [[[HTTPClient alloc] init] autorelease];
        });
        
        it(@"can fetch google's homepage", ^{
            // uses NSURLRequest internally
            [client fetchURLString:@"http://google.com"];
            
            // plain Cedar matcher use - does not wait
            // (passes immediately since it takes sometime to fetch google)
            client.lastResponse should be_nil;
            
            // async matcher use - waits for lastResponse to contain 'Google'
            in_time(client.lastResponse) should contain(@"Google");
        });
    });

    SPEC_END

### Timeout & Polling Interval

Temporarily change timeout and polling interval:

    CedarAsync::Timing::current_timeout = 4; // seconds
    CedarAsync::Timing::current_poll = 0.3;  // seconds

or

    with_timeout(10, ^{
        in_time(valueThatTakesForever) should equal(@"so large...");
    });

Change default timeout and polling interval (these values are used to populate
`current_timeout` and `current_poll` before every test run):

    CedarAsync::Timing::default_timeout = 4; // seconds
    CedarAsync::Timing::default_poll = 2;    // seconds

### Todo

- clean up queued up actions on NSRunLoop, GCD, etc. after every test
