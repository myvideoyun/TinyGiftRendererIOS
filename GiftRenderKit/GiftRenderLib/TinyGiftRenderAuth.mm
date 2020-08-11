#import "TinyGiftRenderAuth.h"
#include "Constants.h"
#include "render_api.h"
#include <string>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

void auth_callback(int type, int ret, const char *info) {
    if (type == ObserverMsg::MSG_TYPE_AUTH) {
        if (ret == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AuthNotify object:nil userInfo:@{AuthUserInfo : @(0)}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:AuthNotify object:nil userInfo:@{AuthUserInfo : @(1)}];
        }
    }
}

Observer auth_observer = { auth_callback };

@implementation TinyGiftRenderAuth

+ (void)requestAuth:(NSString *)appKey auth_length:(int)length {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        renderer_auth(std::string([bundleIdentifier UTF8String]), std::string(appKey.UTF8String), "", length, &auth_observer);
    });
}

@end
