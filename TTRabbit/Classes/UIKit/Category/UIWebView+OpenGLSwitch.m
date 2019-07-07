//
//  UIWebself+OpenGLSwitch.m
//  rollingstoneW
//
//  TTKit on 2019/6/13.
//

#import "UIWebView+OpenGLSwitch.h"
#import <objc/runtime.h>

typedef BOOL (*OpenGLGetFunc)(id, SEL);
typedef void (*OpenGLCallFunc)(id, SEL, BOOL);

@implementation UIWebView (OpenGLSwitch)

- (void)setTt_autoSwitchOpenGLEnabled:(BOOL)tt_autoSwitchOpenGLEnabled {
    if (tt_autoSwitchOpenGLEnabled == self.tt_autoSwitchOpenGLEnabled) {
        return;
    }
    objc_setAssociatedObject(self, @selector(tt_autoSwitchOpenGLEnabled), @(tt_autoSwitchOpenGLEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (tt_autoSwitchOpenGLEnabled) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enableOpenGL)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(disableOpenGL)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (BOOL)tt_autoSwitchOpenGLEnabled {
    return [objc_getAssociatedObject(self, @selector(tt_autoSwitchOpenGLEnabled)) boolValue];
}

- (void)enableOpenGL {
    [self tt_setOpenGLEnabled:YES];
}

- (void)disableOpenGL {
    [self tt_setOpenGLEnabled:NO];
}

- (BOOL)tt_setOpenGLEnabled:(BOOL)enabled {
    BOOL bRet = NO;
    do {
        Ivar internalVar = class_getInstanceVariable([self class], "_internal");
        if (!internalVar) {
            NSLog(@"enable GL _internal invalid!");
            break;
        }
        UIWebViewInternal* internalObj = object_getIvar(self, internalVar);
        Ivar browserVar = class_getInstanceVariable(object_getClass(internalObj), "browserView");
        if (!browserVar) {
            NSLog(@"enable GL browserView invalid!");
            break;
        }
        id webbrowser = object_getIvar(internalObj, browserVar);
        Ivar webViewVar = class_getInstanceVariable(object_getClass(webbrowser), "_webView");
        if (!webViewVar) {
            NSLog(@"enable GL _webView invalid!");
            break;
        }
        id webView = object_getIvar(webbrowser, webViewVar);
        if (!webView) {
            NSLog(@"enable GL webView obj nil!");
        }
        if(object_getClass(webView) != NSClassFromString(@"WebView")) {
            NSLog(@"enable GL webView not WebView!");
            break;
        }
        SEL selector = NSSelectorFromString(@"_setWebGLEnabled:");
        IMP impSet = [webView methodForSelector:selector];
        OpenGLCallFunc func = (OpenGLCallFunc)impSet;
        func(webView, selector, enabled);
        SEL selectorGet = NSSelectorFromString(@"_webGLEnabled");
        IMP impGet = [webView methodForSelector:selectorGet];
        OpenGLGetFunc funcGet = (OpenGLGetFunc)impGet;
        BOOL val = funcGet(webView, selector);
        bRet = (val == enabled);
    } while(NO);
    return bRet;
}

@end
