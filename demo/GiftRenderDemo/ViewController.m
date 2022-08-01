#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <GiftRendererKit/GiftRenderKit.h>

@interface ViewController () <GLKViewDelegate, AYAnimHandlerDelegate>{
    GLKView *glkView;
    CADisplayLink* displayLink;
    
    UIButton *button;
    UISwitch *overlaySwitch;

    NSLock *lock;
    Boolean isAppActive;
}

@property (nonatomic, strong) MVYGiftRenderWrapper *animHandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // download overlay image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *avatarData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://avatars.githubusercontent.com/u/45362645?v=4"]];
            if (avatarData != NULL) {
                UIImage *image = [UIImage imageWithData:avatarData];
                
                // Convert to PNG
                [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                NSLog(@"overlay image download success");

            } else {
                NSLog(@"overlay image download failure");
            }
        });
        
        NSLog(@"overlay image downloading");
    }
    
    int auth_ret = [MVYSDKAuthTool requestAuthEx:@"B7EkZE/J8ucIeYj9mcIytHLhKh9dOSh39hr2ALWHmiXOjj+sUxpNoEL4xlC/im9MK2aaCu6YLlikOlbOzXXEuUqjkufKAcjIVWLiLWmCx3qGjtYurdSmNzTO6NLXXeca8jK8iFOwbQe12FQqiaCb7g==" LicenseLength:112 Key:@"8bQd0ysr85WwOE2eNn3y1o9dLingLBM2jUOUZ+WnLY0CyXUsw+yrP2tn/Z9R/7bASFOmiq61l+yQUFqsv17wPg==" KeyLength:64];

    if (auth_ret == 0)
        NSLog(@"Authenticate OK!");
    else
        NSLog(@"Authenticate FAIL");
    
    // add background view
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
    
    CGFloat screenWidth = self.view.bounds.size.width ;
    CGFloat screenHeight = self.view.bounds.size.height;
    
    // add play button
    button = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth / 2 - 50, screenHeight - 100, 100, 50)];
    [button setTitle:@"play" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.grayColor];
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // add switch button
    overlaySwitch = [[UISwitch alloc] init];
    [overlaySwitch setCenter: CGPointMake(screenWidth / 2 + 30, screenHeight - 150)];
    [self.view addSubview:overlaySwitch];
    
    // add switch label
    UILabel *overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth / 2 - 100, screenHeight - 150, 100, 50)];
    [overlayLabel setCenter: CGPointMake(screenWidth / 2 - 30, screenHeight - 150)];
    [overlayLabel setText:@"overlay"];
    [overlayLabel setTextColor:UIColor.whiteColor];
    [overlayLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:overlayLabel];
    
    // 监听进入后台前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

// click play or stop button
- (void)onButtonClick:(UIButton *)btn {
    if ([btn.currentTitle isEqualToString:@"play"]) {
        self.animHandler.effectPath = [[NSBundle mainBundle] pathForResource:@"overlay_setting1" ofType:@"json" inDirectory:@"yurenjie"];
        [self.animHandler setEffectPlayCount:2];
        [button setTitle:@"stop" forState:UIControlStateNormal];
        
        // process overlay
        if (overlaySwitch.isOn) {
            [self addOverlay];
        } else {
            self.animHandler.overlayPath = @"";
        }
        
    } else if ([btn.currentTitle isEqualToString:@"stop"]) {
        self.animHandler.effectPath = @"";
        self.animHandler.overlayPath = @"";
        [button setTitle:@"play" forState:UIControlStateNormal];

    }
}

// add overlay when render
- (void)addOverlay {
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.animHandler.overlayPath = filePath;
    } else {
        NSLog(@"overlay image download failure");
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
    NSLog(@"多次播放完成 return %d", ret);
//    [displayLink invalidate];
//    _animHandler = nil;
    
    [button setTitle:@"play" forState:UIControlStateNormal];
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
        // set to 1 to enable hardware decode
        if((0))
            _animHandler = [[MVYGiftRenderWrapper alloc] initWithHardwareDecoder];
        else
            _animHandler = [[MVYGiftRenderWrapper alloc] init];
        
        
//        self.animHandler.effectPath = [[NSBundle mainBundle] pathForResource:@"meta" ofType:@"json" inDirectory:@"yurenjie"];
//        self.animHandler.overlayPath = [[NSBundle mainBundle] pathForResource:@"xin_19" ofType:@"png" inDirectory:@"yurenjie"];
//        self.animHandler.effectPlayCount = 2;
        
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
