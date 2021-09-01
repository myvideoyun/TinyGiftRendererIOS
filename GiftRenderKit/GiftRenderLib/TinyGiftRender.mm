#include <string>
#import "TinyGiftRender.h"
#import "render_api.h"

/**
 * 特效播放中
 */
int MSG_STAT_EFFECTS_PLAY = 0x00020000;

/**
 * 特效播放结束
 */
int MSG_STAT_EFFECTS_END = 0x00040000;

/**
 * 特效播放开始
 */
int MSG_STAT_EFFECTS_START = 0x00080000;

class AyEffectCallBack
{
public:
    TinyGiftRender *ayEffect;

    void effectMessage(int type, int ret, const char *info){
        if (ayEffect.delegate) {
            [ayEffect.delegate effectMessageWithType:type ret:ret];
        }
    }
};

@interface TinyGiftRender () {
    void* render;
    AyEffectCallBack effectCallBack;

    BOOL updateEffectPath;
    BOOL updateVFlip;
}
@end

@implementation TinyGiftRender
- (void)initGLResource:(int)decode_mode {
    effectCallBack.ayEffect = self;
    render = renderer_create(0);
    MsgCallback cb;
    cb.callback = std::bind(&AyEffectCallBack::effectMessage, &effectCallBack, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3);
    renderer_setParam(render, "MsgFunction", (void*)&cb);
    if(decode_mode){
        renderer_setParam(render, "EnableHWDec", &decode_mode);
    }
    updateVFlip = false;
}

- (void)releaseGLtContext {
    renderer_releaseResources(render);
}

- (void)setEffectPath:(NSString *)effectPath {
    _effectPath = effectPath;

    updateEffectPath = YES;
}

- (void)setFaceData:(void *)faceData{
    // TODO: implement
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
