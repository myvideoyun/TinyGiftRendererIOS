#import <Foundation/Foundation.h>

extern NSString *const AuthNotify;
extern NSString *const AuthUserInfo;

@interface SDKAuthTool : NSObject

/**
 初始化lisence
 异步请求服务器确认lisence
 */
+ (void)requestAuth:(NSString *)appKey auth_length:(int)length;

@end
