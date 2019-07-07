//
//  UIWebView+OpenGLSwitch.h
//  rollingstoneW
//
//  TTKit on 2019/6/13.
//
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 如果webview中使用了OpenGL技术，在进入后台会闪退。需要进入后台关闭OpenGL，进前台再次开启OpenGL
*/
@interface UIWebView (OpenGLSwitch)

/**
 是否可以进入前后台自动开关OpenGL
 */
@property (nonatomic, assign) BOOL tt_autoSwitchOpenGLEnabled;

/**
 开或者关闭OpenGL

 @param enabled YES为开，NO为关
 @return 执行的结果
 */
- (BOOL)tt_setOpenGLEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
