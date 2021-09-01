#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

extern NSString *const MVYGiftRenderNotification;
extern NSString *const MVYGiftRenderUserInfo;


@protocol AYAnimHandlerDelegate <NSObject>

/**
 播放结束
 */
- (void)playEnd:(int)ret;

@end
@interface MVYGiftRenderWrapper : NSObject

@property (nonatomic, weak) id<AYAnimHandlerDelegate> delegate;

/**
 set gift path
 */
@property(nonatomic, strong) NSString *effectPath;

/**
 设置礼物播放次数
 */
@property(nonatomic, assign) NSUInteger effectPlayCount;

/**
 使用软解码器
 */
- (instancetype)initWithSoftwareDecoder;

/**
 使用硬解码器
 */
- (instancetype)initWithHardwareDecoder;


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
