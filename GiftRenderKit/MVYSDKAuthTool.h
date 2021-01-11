#import <Foundation/Foundation.h>

@interface MVYSDKAuthTool : NSObject

+ (int)requestAuth:(NSString *)appKey auth_length:(int)length;
+ (int)requestAuthEx:(NSString *)license LicenseLength:(int)license_length Key:(NSString *)appKey KeyLength:(int)length;

@end
