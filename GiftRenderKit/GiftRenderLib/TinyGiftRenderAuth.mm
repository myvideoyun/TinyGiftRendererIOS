#import "TinyGiftRenderAuth.h"
#include "render_api.h"
#include <string>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

@implementation TinyGiftRenderAuth

+ (int)requestAuth:(NSString *)appKey auth_length:(int)length {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    return renderer_auth(std::string([bundleIdentifier UTF8String]), std::string(appKey.UTF8String), length);
}

+ (int)requestAuthEx:(NSString *)license license_length:(int)license_length key_str:(NSString *)appKey auth_length:(int)length {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    return renderer_auth_ex(std::string([bundleIdentifier UTF8String]), std::string(license.UTF8String), license_length, std::string(appKey.UTF8String), length);
}
@end
