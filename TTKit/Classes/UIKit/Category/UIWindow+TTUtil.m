//
//  UIWindow+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIWindow+TTUtil.h"

@implementation UIWindow (TTUtil)

+ (UIWindow *)tt_topWindow {
    __block UIWindow *topWindow = nil;
    [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(UIWindow *window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (window.windowLevel > topWindow.windowLevel) {
            topWindow = window;
        } else if (window.windowLevel == topWindow.windowLevel && window.isKeyWindow) {
            topWindow = window;
        }
    }];
    return topWindow;
}

+ (UIWindow *)tt_keyboardWindow {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    //逆序效率更高，因为键盘总在上方
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([NSStringFromClass([window class]) isEqualToString:@"UIRemoteKeyboardWindow"] ) {
            return window;
        }
    }
    return nil;
}

+ (UIWindow *)tt_mainWindow {
    return [[UIApplication sharedApplication].delegate window];
}

@end
