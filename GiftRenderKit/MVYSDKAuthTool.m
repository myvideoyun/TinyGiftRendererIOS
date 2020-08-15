#import "MVYSDKAuthTool.h"
#import "TinyGiftRenderAuth.h"

@implementation MVYSDKAuthTool

+ (void)requestAuth:(NSString *)appKey auth_length:(int)length{
    [TinyGiftRenderAuth requestAuth:appKey auth_length:length];
}

@end
