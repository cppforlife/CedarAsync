#import "ExpectCallLength.h"

using namespace Cedar::Matchers;

NSTimeInterval callLength(void(^block)(void)) {
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    block();
    return [[NSDate date] timeIntervalSince1970] - start;
}

void expectShortCallLength(void(^block)(void)) {
    callLength(block) should be_less_than(0.001);
}

void expectLongCallLength(void(^block)(void)) {
    callLength(block) should be_greater_than(0.001);
}
