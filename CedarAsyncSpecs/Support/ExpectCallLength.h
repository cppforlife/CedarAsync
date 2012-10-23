#import <Foundation/Foundation.h>

__BEGIN_DECLS
NSTimeInterval callLength(void(^call)(void));
void expectShortCallLength(void(^call)(void));
void expectLongCallLength(void(^call)(void));
__END_DECLS
