#import <Foundation/Foundation.h>

extern NSString *const AuthNotify;
extern NSString *const AuthUserInfo;

@interface TinyGiftRenderAuth : NSObject

+ (void)requestAuth:(NSString *)appKey auth_length:(int)length;

@end
