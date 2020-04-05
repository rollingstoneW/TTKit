//
//  UIDevice+TTUtil.m
//  TTKit
//
//  TTKit on 2019/6/11.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIDevice+TTUtil.h"

@implementation UIDevice (TTUtil)

+ (CGFloat)tt_statusBarHeight {
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
    return height ?: ([self tt_isFullScreen] ? 44 : 20);
}

+ (CGFloat)tt_navigationBarHeight {
    static CGFloat navigationBarHeight = 0;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        navigationBarHeight = [[UINavigationBar new] sizeThatFits:CGSizeZero].height;
    });
    return navigationBarHeight;
}

+ (CGFloat)tt_navigationBarBottom {
    return [self tt_statusBarHeight] + [self tt_navigationBarHeight];
}

+ (CGFloat)tt_tabBarHeight {
    static CGFloat tabBarHeight = 0;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        tabBarHeight = [[UITabBar new] sizeThatFits:CGSizeZero].height;
    });
    return tabBarHeight + [self tt_safeAreaBottom];
}

+ (CGFloat)tt_safeAreaBottom {
    if (@available(iOS 11.0, *)) {
        return [[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom;
    }
    return 0;
}

+ (BOOL)tt_isFullScreen {
    if (@available(iOS 11.0, *)) { \
        return [[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom > 0;
    }
    return NO;
}

@end
