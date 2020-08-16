#import "MVYSDKAuthTool.h"
#import "TinyGiftRenderAuth.h"

@implementation MVYSDKAuthTool

+ (int)requestAuth:(NSString *)appKey auth_length:(int)length{
    return [TinyGiftRenderAuth requestAuth:appKey auth_length:length];
}

@end
