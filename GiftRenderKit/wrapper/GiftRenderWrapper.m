#import "GiftRenderWrapper.h"
#import "TinyGiftRender.h"

@interface GiftRenderWrapper ()
@property(nonatomic, strong) TinyGiftRender *effect;

@property(nonatomic, assign) NSInteger currentPlayCount;
@end

@implementation GiftRenderWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        _effect = [[TinyGiftRender alloc] init];
        [self.effect initGLResource];
        self.effect.enalbeVFilp = YES;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:RenderNotification object:nil];
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

- (void)notifyMessage:(NSNotification *)notifi {
    NSString *message = notifi.userInfo[RenderUserInfo];

    if (!self.effectPath || [self.effectPath isEqualToString:@""]) {

    } else if ([@"TINYGIFT_END" isEqualToString:message]) { //已经渲染完成一遍
        self.currentPlayCount++;
        if (self.effectPlayCount != 0 && self.currentPlayCount >= self.effectPlayCount) {
            [self setEffectPath:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:RenderNotification object:nil userInfo:@{ RenderUserInfo : @"TINYGIFT_REPLAY_END" }];
        }
    } else if (self.effectPlayCount != 0 && self.currentPlayCount >= self.effectPlayCount) { //已经播放完成
        [self setEffectPath:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:RenderNotification object:nil userInfo:@{ RenderUserInfo : @"TINYGIFT_REPLAY_END" }];
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
