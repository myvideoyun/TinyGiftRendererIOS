#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

/**
 * 特效播放中
 */
extern int MSG_STAT_EFFECTS_PLAY;

/**
 * 特效播放结束
 */
extern int MSG_STAT_EFFECTS_END;

/**
 * 特效播放开始
 */
extern int MSG_STAT_EFFECTS_START;

@protocol AyEffectDelegate <NSObject>
@optional
/**
 特效数据回调
 */
- (void)effectMessageWithType:(NSInteger)type ret:(NSInteger)ret;

@end

extern NSString *const MVYGiftRenderNotification;
extern NSString *const MVYGiftRenderUserInfo;

@interface TinyGiftRender : NSObject

@property (nonatomic, weak) id<AyEffectDelegate> delegate;

/**
 特效文件路径
 */
@property(nonatomic, strong) NSString *effectPath;

/**
 垂直翻转帧动画, 默认关
 */
@property(nonatomic, assign) BOOL enalbeVFilp;

/**
 初始化opengl相关的资源
 */
- (void)initGLResource:(int)decode_mode;

/**
 释放opengl相关的资源
 */
- (void)releaseGLtContext;

/**
 绘制特效
 
 @param texture 纹理数据, 
 @param width 宽度
 @param height 高度
 */
- (void)processWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height;

/**
 暂停绘制特效
 */
- (void)pauseProcess;

/**
 恢复绘制特效
 */
- (void)resumeProcess;

@end
