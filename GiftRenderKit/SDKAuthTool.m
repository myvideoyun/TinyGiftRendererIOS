#import "SDKAuthTool.h"
#import "TinyGiftRenderAuth.h"

@implementation SDKAuthTool

+ (void)requestAuth:(NSString *)appKey auth_length:(int)length{
    [TinyGiftRenderAuth requestAuth:appKey auth_length:length];
}

@end
