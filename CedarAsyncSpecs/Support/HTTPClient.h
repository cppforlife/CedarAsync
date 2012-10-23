#import <Foundation/Foundation.h>

@interface HTTPClient : NSObject
@property (nonatomic, retain) NSString *lastResponse;

- (void)fetchURLString:(NSString *)urlString;
@end
