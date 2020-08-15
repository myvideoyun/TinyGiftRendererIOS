#import <Foundation/Foundation.h>

@interface TinyGiftRenderAuth : NSObject

+ (int)requestAuth:(NSString *)appKey auth_length:(int)length;

@end
