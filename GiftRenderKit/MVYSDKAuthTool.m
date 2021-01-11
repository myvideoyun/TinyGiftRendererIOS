#import "MVYSDKAuthTool.h"
#import "TinyGiftRenderAuth.h"

@implementation MVYSDKAuthTool

+ (int)requestAuth:(NSString *)appKey auth_length:(int)length{
    return [TinyGiftRenderAuth requestAuth:appKey auth_length:length];
}

+ (int)requestAuthEx:(NSString *)license LicenseLength:(int)license_length Key:(NSString *)appKey KeyLength:(int)length{
    return [TinyGiftRenderAuth requestAuthEx:license LicenseLength:license_length Key:appKey KeyLength:length];
}
@end
