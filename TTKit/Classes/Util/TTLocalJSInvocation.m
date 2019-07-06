//
//  TTLocalJSInvocation.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/28.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTLocalJSInvocation.h"
#import <WebKit/WebKit.h>

@interface TTLocalJSInvocation () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, copy) NSString *injectionJS;

@property (nonatomic, strong) NSMutableArray *JSToEvaluate;

@end

@implementation TTLocalJSInvocation

- (nullable instancetype)initWithName:(NSString *)name functions:(NSArray<NSString *> *)functions bundle:(nullable NSBundle *)bundle {
    if (!name.length || !functions.count) {
        NSAssert(NO, @"js名称和函数不能为空");
        return nil;
    }
    NSString *path = [(bundle ?: [NSBundle mainBundle]) pathForResource:name ofType:@"js"];
    return [self initWithPath:path functions:functions];
}

- (nullable instancetype)initWithPath:(NSString *)path functions:(NSArray<NSString *> *)functions {
    if (!path) {
        NSAssert(path, @"路径不存在");
        return nil;
    }
    NSString *JS = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (!JS.length) {
        NSAssert(path, @"js格式不正确");
        return nil;
    }
    if (self = [super init]) {
//        NSString *prefix = @"(function(win) {\n'use strict'\nconst $ = (selector) => doc.querySelector(selector)\n";
//        NSMutableString *suffix = [NSMutableString string];
//        for (NSString *function in functions) {
//            [suffix appendString:[NSString stringWithFormat:@"win.%@ = %@\n", function, function]];
//        }
//        [suffix appendString:@"}(window));"];
//        self.injectionJS = [NSString stringWithFormat:@"%@%@%@", prefix, JS, suffix];
        self.injectionJS = JS;
        self.JSToEvaluate = [NSMutableArray array];
        
        [self loadWebview];
    }
    return self;
}

- (void)evaluateJS:(NSString *)JS withCompletion:(void (^)(id _Nonnull value, NSError * _Nonnull))completion {
    if (!JS || !completion) {
        return;
    }
    if (!self.webview) {
        [self loadWebview];
    }
    if (self.webview.isLoading) {
        [self.JSToEvaluate addObject:@{@"JS":JS, @"completion":completion}];
    } else {
        [self.webview evaluateJavaScript:JS completionHandler:^(JSValue *value, NSError * _Nullable error) {
            completion(value, error);
        }];
    }
}

- (void)loadWebview {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];

    WKUserScript *script = [[WKUserScript alloc] initWithSource:self.injectionJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];

    WKPreferences *preference = [[WKPreferences alloc] init];
    preference.javaScriptEnabled = YES;
    config.preferences = preference;

    WKWebView *wkWebview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    // 加载空页面
    [wkWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    wkWebview.navigationDelegate = self;
    self.webview = wkWebview;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(releaseWebview)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

- (void)evaluateJSIfNeeded {
    if (self.JSToEvaluate.count) {
        [[self.JSToEvaluate copy] enumerateObjectsUsingBlock:^(NSDictionary *JSInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.JSToEvaluate removeObjectAtIndex:idx];
            [self.webview evaluateJavaScript:JSInfo[@"JS"] completionHandler:^(id value, NSError * _Nullable error) {
                void(^completion)(id value, NSError *error) = JSInfo[@"completion"];
                completion(value, error);
            }];
        }];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self evaluateJSIfNeeded];
}

- (void)releaseWebview {
    [self.webview stopLoading];
    self.webview.navigationDelegate = nil;
    self.webview = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self releaseWebview];
}

@end
