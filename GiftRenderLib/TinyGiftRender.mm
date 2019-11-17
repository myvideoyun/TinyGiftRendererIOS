#include <string>
#import "TinyGiftRender.h"
#include "Constants.h"
#import "render_api.h"

void funcAyEffectMessage(int type, int ret, const char *info) {
    [[NSNotificationCenter defaultCenter]
            postNotificationName:RenderNotification
                          object:nil
                        userInfo:@{ RenderUserInfo : [NSString stringWithUTF8String:info] }];
}

@interface TinyGiftRender () {
    void* render;

    BOOL updateEffectPath;
    BOOL updateVFlip;
}
@end

@implementation TinyGiftRender

- (void)initGLResource {
    render = renderer_create(1);
    MsgCallback cb;
    cb.callback = funcAyEffectMessage;
    renderer_setParam(render, "MsgFunction", (void*)&cb);
}

- (void)releaseGLtContext {
    renderer_releaseResources(render);
}

- (void)setEffectPath:(NSString *)effectPath {
    _effectPath = effectPath;

    updateEffectPath = YES;
}

- (void)setEnalbeVFilp:(BOOL)enalbeVFilp {
    _enalbeVFilp = enalbeVFilp;

    updateVFlip = YES;
}

- (void)processWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height {
    if (updateEffectPath) {
        std::string path = std::string([_effectPath UTF8String]);
        renderer_setParam(render, "StickerType", (void *)path.c_str());

        updateEffectPath = NO;
    }

    renderer_setParam(render, "FaceData", NULL);

    if (updateVFlip) {
        int enable = self.enalbeVFilp;
        renderer_setParam(render, "EnableVFlip", &enable);
    }

    renderer_render(render, texture, width, height, NULL);
}

- (void)pauseProcess {
    int defaultValue = 1;
    renderer_setParam(render, "Pause", &defaultValue);
}

- (void)resumeProcess {
    int defaultValue = 1;
    renderer_setParam(render, "Resume", &defaultValue);
}

@end
