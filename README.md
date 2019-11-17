# TinyGiftRenderer

  迷你礼物渲染库功能强大，全面兼容安卓IOS，使用简单；

## 功能

1. 渲染贴纸挂件，如猫耳朵
2. 渲染大型礼物素材

## 特点

1. 素材体积小
2. 渲染速度快
3. 扩展灵活，支持新的挂件特效
4. 使用简单
5. 兼容性好
6. 授权方式灵活

## 商务合作
联系人：范经理  
邮箱：marketing@myvideoyun.com  
电话：+8613818445512

## 使用方式
### IOS
1. 认证鉴权
```
[SDKAuthTool requestAuth:@"NkkOmEE7rb5haWEHWjLTrrlf0fgEdU7eiVCnS0JHhlYpVMhljTSC00MxS4xFTArR" auth_length:48];
```

2. 创建TinyGiftRenderer
```
@property (nonatomic, strong) GiftRenderWrapper *animHandler;
_animHandler = [[GiftRenderWrapper alloc] init];
```
Note: 这个需要在GL线程中创建？

3. 设置资源路径
```
self.animHandler.effectPath = [[NSBundle mainBundle] pathForResource:@"meta" ofType:@"json" inDirectory:@"fjkt"];
```
Note: 需要在GL线程中设置

4. 渲染
```
[self.animHandler processWithWidth:(int)glkView.drawableWidth height:(int)glkView.drawableHeight];
```

具体可参考demo/GiftRenderDemo/ViewContgroller.m.
