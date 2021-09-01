#import "MVYGiftRenderWrapper.h"
#import "TinyGiftRender.h"

NSString *const MVYGiftRenderNotification = @"GiftRenderNotification";
NSString *const MVYGiftRenderUserInfo = @"GiftRenderResult";

@interface MVYGiftRenderWrapper () <AyEffectDelegate>
@property(nonatomic, strong) TinyGiftRender *effect;

@property(nonatomic, assign) NSInteger currentPlayCount;
@end

@implementation MVYGiftRenderWrapper

- (instancetype)initWithSoftwareDecoder {
    self = [super init];
    if (self) {
        _effect = [[TinyGiftRender alloc] init];
        [self.effect initGLResource:0];
        self.effect.enalbeVFilp = NO;
        self.effect.delegate = self;
    }
    return self;
}

- (instancetype)initWithHardwareDecoder {
    self = [super init];
    if (self) {
        _effect = [[TinyGiftRender alloc] init];
        [self.effect initGLResource:1];
        self.effect.enalbeVFilp = NO;
        self.effect.delegate = self;
    }
    return self;
}

- (void)processWithWidth:(GLint)width height:(GLint)height {
    glEnable(GL_BLEND);

    [self.effect processWithTexture:0 width:width height:height];

    glDisable(GL_BLEND);
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
        
    }else if (ret == MSG_STAT_EFFECTS_END || ret < 0) {
        self.currentPlayCount ++;
        [self setEffectPath:@""];
        if (self.delegate) {
            [self.delegate playEnd:ret];
        }
    }else if (self.effectPlayCount != 0 && self.currentPlayCount >= self.effectPlayCount) {
        [self setEffectPath:@""];
        if (self.delegate) {
            [self.delegate playEnd:ret];
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
