#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GiftRenderWrapper : NSObject

/**
 设置礼物,通过设置特效文件路径的方式,默认空值,空值表示取消渲染特效
 */
@property(nonatomic, strong) NSString *effectPath;

/**
 设置礼物播放次数
 */
@property(nonatomic, assign) NSUInteger effectPlayCount;

/**
 暂停礼物播放
 */
- (void)pauseEffect;

/**
 继续礼物播放
 */
- (void)resumeEffect;

/**
 绘制动画
 
 @param width 宽度
 @param height 高度
 */
- (void)processWithWidth:(GLint)width height:(GLint)height;

@end
