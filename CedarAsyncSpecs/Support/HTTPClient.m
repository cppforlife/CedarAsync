#import "HTTPClient.h"

@interface HTTPClient ()
@property (nonatomic, retain) NSMutableData *responseData;
@end

@implementation HTTPClient

- (void)dealloc {
    self.responseData = nil;
    self.lastResponse = nil;
    [super dealloc];
}

- (void)fetchURLString:(NSString *)urlString {
    self.responseData = [NSMutableData data];
    self.lastResponse = nil;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.lastResponse = [[[NSString alloc] initWithData:self.responseData encoding:NSASCIIStringEncoding] autorelease];
}
@end
