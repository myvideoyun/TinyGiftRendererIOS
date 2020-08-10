#import "GiftRenderWrapper.h"
#import "../GiftRenderLib/TinyGiftRender.h"

@interface GiftRenderWrapper () <AyEffectDelegate>
@property(nonatomic, strong) TinyGiftRender *effect;

@property(nonatomic, assign) NSInteger currentPlayCount;
@end

@implementation GiftRenderWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        _effect = [[TinyGiftRender alloc] init];
        [self.effect initGLResource];
        self.effect.enalbeVFilp = NO;
        self.effect.delegate = self;
    }
    return self;
}

- (void)processWithWidth:(GLint)width height:(GLint)height {
    //------------->绘制图像<--------------//
    glEnable(GL_BLEND);

    [self.effect processWithTexture:0 width:width height:height];

    glDisable(GL_BLEND);
    //------------->绘制图像<--------------//
}

- (void)setEffectPath:(NSString *)effectPath {
    _effectPath = effectPath;

    [self.effect setEffectPath:effectPath];
}

- (void)setEffectPlayCount:(NSUInteger)effectPlayCount {
    _effectPlayCount = effectPlayCount;
    self.currentPlayCount = 0;
}

- (void)effectMessageWithType:(NSInteger)type ret:(NSInteger)ret {
    
    if (!self.effectPath || [self.effectPath isEqualToString:@""]){
        
    }else if (ret == MSG_STAT_EFFECTS_END || ret < 0) {//已经渲染完成一遍
        self.currentPlayCount ++;
        [self setEffectPath:@""];
        if (self.delegate) {
            [self.delegate playEnd];
        }
    }else if (self.effectPlayCount != 0 && self.currentPlayCount >= self.effectPlayCount) {//已经播放完成
        [self setEffectPath:@""];
        if (self.delegate) {
            [self.delegate playEnd];
        }
    }
}

- (void)pauseEffect {
    [self.effect pauseProcess];
}

- (void)resumeEffect {
    [self.effect resumeProcess];
}

- (void)dealloc {
    [self.effect releaseGLtContext];
}

@end
