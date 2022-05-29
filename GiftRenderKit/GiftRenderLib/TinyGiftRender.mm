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
    BOOL updateOverlayPath;
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
    renderer_destropy(render);
}

- (void)setEffectPath:(NSString *)effectPath {
    _effectPath = effectPath;

    updateEffectPath = YES;
}

- (void)setOverlayPath:(NSString *)path {
    _overlayPath = path;

    updateOverlayPath = YES;
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
    if(updateOverlayPath){
        std::string path = std::string([_overlayPath UTF8String]);
        renderer_setParam(render, "OverlayImgPath", (void *)path.c_str());

        updateOverlayPath = NO;
    }

    if (updateVFlip) {
        int enable = self.enalbeVFilp;
        renderer_setParam(render, "EnableVFlip", &enable);
    }
    int setup_modelview = false;
    if(setup_modelview){
        const float modelview[16] = {
            0.999559f,  0.006781f,  -0.028911f, 0.000000f,
            -0.005831f, 0.999445f,  0.032811f,  0.000000f,
            0.029117f,  -0.032628f, 0.999043f,  0.000000f,
            0.001027f,  0.004984f,  -0.864680f, 1.000000f};
        renderer_setParam(render, "ModelView", (void *)modelview);
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
