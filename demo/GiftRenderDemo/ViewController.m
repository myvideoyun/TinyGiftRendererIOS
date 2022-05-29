#import "ViewController.h"
#import <GLKit/GLKit.h>
#import "GiftRenderKit/GiftRenderKit.h"

@interface ViewController () <GLKViewDelegate, AYAnimHandlerDelegate>{
    GLKView *glkView;
    CADisplayLink* displayLink;
    
    UIButton *button;
    
    NSLock *lock;
    Boolean isAppActive;
}

@property (nonatomic, strong) MVYGiftRenderWrapper *animHandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int auth_ret = [MVYSDKAuthTool requestAuthEx:@"B7EkZE/J8ucIeYj9mcIytHLhKh9dOSh39hr2ALWHmiXOjj+sUxpNoEL4xlC/im9MK2aaCu6YLlikOlbOzXXEuUqjkufKAcjIVWLiLWmCx3qGjtYurdSmNzTO6NLXXeca8jK8iFOwbQe12FQqiaCb7g==" LicenseLength:112 Key:@"8bQd0ysr85WwOE2eNn3y1o9dLingLBM2jUOUZ+WnLY0CyXUsw+yrP2tn/Z9R/7bASFOmiq61l+yQUFqsv17wPg==" KeyLength:64];

    if (auth_ret == 0)
        NSLog(@"Authenticate OK!");
    else
        NSLog(@"Authenticate FAIL");
    // add blue view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"girl"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    //使用GLKit创建opengl渲染环境
    glkView = [[GLKView alloc]initWithFrame:self.view.bounds context:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]];
    glkView.backgroundColor = [UIColor clearColor];
    glkView.delegate = self;
    
    // add glkview
    [self.view addSubview:glkView];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    displayLink.frameInterval = 2;// 帧率 = 60 / frameInterval
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self->isAppActive = true;
    self->lock = [[NSLock alloc] init];
    
    // add button
    button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 50, self.view.bounds.size.height - 100, 100, 50)];
    [button setTitle:@"stop" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.grayColor];
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    // 监听进入后台前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)onButtonClick:(UIButton *)btn {
    if ([btn.currentTitle isEqualToString:@"play"]) {
        self.animHandler.effectPath = [[NSBundle mainBundle] pathForResource:@"meta" ofType:@"json" inDirectory:@"aixinmeigui_v1"];
        [self.animHandler setEffectPlayCount:1];
        [button setTitle:@"stop" forState:UIControlStateNormal];
        
    } else if ([btn.currentTitle isEqualToString:@"stop"]) {
        self.animHandler.effectPath = @"";
        [button setTitle:@"play" forState:UIControlStateNormal];

    }
}

- (void)didEnterBackground {
    [lock lock];
    self->isAppActive = false;
    NSLog(@"didEnterBackground");
    [lock unlock];
}

- (void)willEnterForeground {
    [lock lock];
    self->isAppActive = true;
    NSLog(@"willEnterForeground");
    [lock unlock];
}

- (void)playEnd:(int)ret {
    NSLog(@"多次播放完成");
    [displayLink invalidate];
    _animHandler = nil;
}

#pragma mark CADisplayLink selector
- (void)render:(CADisplayLink*)displayLink {
    [glkView display];
}

#pragma mark GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [lock lock];
    
    if (self->isAppActive == false) {
        [lock unlock];
        return;
    }
    
    if (!_animHandler) {
        //初始化AiyaAnimEffect
        _animHandler = [[MVYGiftRenderWrapper alloc] initWithHardwareDecoder];
        self.animHandler.effectPath = [[NSBundle mainBundle] pathForResource:@"meta" ofType:@"json" inDirectory:@"dog_model"];
        self.animHandler.effectPlayCount = 2;
        self.animHandler.delegate = self;
    }
    
    //清空画布
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.animHandler processWithWidth:(int)glkView.drawableWidth height:(int)glkView.drawableHeight];
    
    [lock unlock];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
