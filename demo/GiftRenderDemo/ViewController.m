#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <GiftRenderKit/GiftRenderKit.h>

@interface ViewController () <GLKViewDelegate>{
    GLKView *glkView;
    CADisplayLink* displayLink;
}

@property (nonatomic, strong) GiftRenderWrapper *animHandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // license state notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(licenseMessage:) name:AuthNotify object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:RenderNotification object:nil];
    
    [SDKAuthTool requestAuth:@"jAwdRWLiAhQN3lJ2zfJv7blf0fgEdU7eiVCnS0JHhlYpVMhljTSC00MxS4xFTArR" auth_length:64];
    
    // add blue view
    UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
    v.backgroundColor = [UIColor blueColor];
    [self.view addSubview:v];
    
    //使用GLKit创建opengl渲染环境
    glkView = [[GLKView alloc]initWithFrame:self.view.bounds context:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]];
    glkView.backgroundColor = [UIColor clearColor];
    glkView.delegate = self;
    
    // add glkview
    [self.view addSubview:glkView];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    displayLink.frameInterval = 4;// 帧率 = 60 / frameInterval
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)licenseMessage:(NSNotification *)notifi{
    
    AuthResult result = [notifi.userInfo[AuthUserInfo] integerValue];
    switch (result) {
        case AuthSuccess:
            NSLog(@"License 验证成功");
            break;
        case AuthFail:
            NSLog(@"License 验证失败");
            break;
    }
}

- (void)notifyMessage:(NSNotification *)notifi{
    
    NSString *message = notifi.userInfo[RenderUserInfo];
    if ([@"TINYGIFT_REPLAY_END" isEqualToString:message]) {
        NSLog(@"多次播放完成");
        [displayLink invalidate];
    }
}

#pragma mark CADisplayLink selector
- (void)render:(CADisplayLink*)displayLink {
    [glkView display];
}

#pragma mark GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    if (!_animHandler) {
        //初始化AiyaAnimEffect
        _animHandler = [[GiftRenderWrapper alloc] init];
        self.animHandler.effectPath = [[NSBundle mainBundle] pathForResource:@"meta" ofType:@"json" inDirectory:@"fjkt"];
        self.animHandler.effectPlayCount = 2;
    }
    
    //清空画布
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);  
    
    [self.animHandler processWithWidth:(int)glkView.drawableWidth height:(int)glkView.drawableHeight];

}


@end
