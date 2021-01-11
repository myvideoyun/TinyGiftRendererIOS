#import <Foundation/Foundation.h>

@interface MVYSDKAuthTool : NSObject

+ (int)requestAuth:(NSString *)appKey auth_length:(int)length;
+ (int)requestAuthEx:(NSString *)license license_length:(int)license_length key_str:(NSString *)appKey key_length:(int)length;

@end
