//
//  TTUIMacros.h
//  TTRabbit
//
//  Created by rollingstoneW on 2019/7/18.
//

#ifndef TTUIMacros_h
#define TTUIMacros_h

#pragma mark - Constants

#ifndef kScreenWidth
#define kScreenWidth                      [[UIScreen mainScreen] bounds].size.width
#endif
#ifndef kScreenHeight
#define kScreenHeight                     [[UIScreen mainScreen] bounds].size.height
#endif

#define kScreenShortSide                  MIN(kScreenWidth, kScreenHeight)
#define kScreenLongSide                   MAX(kScreenWidth, kScreenHeight)

#define kNavigationBarHeight              [UIDevice tt_navigationBarHeight]
#define kCurrentStatusBarHeight           [UIApplication sharedApplication].statusBarFrame.size.height
#define kStatusBarHeight                  (kCurrentStatusBarHeight ?: (TTDeviceIsFullScreen ? 44 : 20))
#define kNavigationBarBottom              (kStatusBarHeight + kNavigationBarHeight)
#define kTabBarHeight                     ([UIDevice tt_tabBarHeight] + kWindowSafeAreaBottom)
#define kWindowSafeAreaBottom             ({ \
CGFloat bottom = 0; \
if (@available(iOS 11.0, *)) { \
bottom = [[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom; \
} \
bottom; \
})

#define kWidth_1px                        (1 / [UIScreen mainScreen].scale)
#define kMarginLeft                       15

#define kAppDelegate                      ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kMainWindow                       [[UIApplication sharedApplication].delegate window]
#define kKeyWindow                        [UIApplication sharedApplication].keyWindow

#pragma mark - Device

#define TTDeviceIsPad       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define TTDeviceIsPhone     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断iPhoneX
#define TTDeviceIsIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && TTDeviceIsPhone : NO)
//判断iPHoneXr
#define TTDeviceIsIphoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && TTDeviceIsPhone : NO)
//判断iPhoneXs
#define TTDeviceIsIphoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && TTDeviceIsPhone : NO)
//判断iPhoneXs Max
#define TTDeviceIsIphoneXS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && TTDeviceIsPhone : NO)
//判断是否为全面屏
#define TTDeviceIsFullScreen (kWindowSafeAreaBottom > 0)

#define TTDeviceIsLandscape                      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#pragma mark - UIAdapter

#define TTAdaptedWidth4(width)             (width * (kScreenWidth / 320))
#define TTAdaptedWidth47(width)            (width * (kScreenWidth / 375))
#define k1dot5ValueOniPad(value) TTAdaptedValueForScreen5(value, value * 1.5)

#define TTAdaptedValueForScreen1(small, normal) TTAdaptedValueForScreen(small, normal, normal, normal, normal)
#define TTAdaptedValueForScreen2(small, normal, x) TTAdaptedValueForScreen(small, normal, x, normal, normal)
#define TTAdaptedValueForScreen6(small, normal, ipad) TTAdaptedValueForScreen(small, normal, normal, normal, ipad)
#define TTAdaptedValueForScreen3(small, normal, x, ipad) TTAdaptedValueForScreen(small, normal, x, normal, ipad)
#define TTAdaptedValueForScreen4(normal, x, ipad) TTAdaptedValueForScreen(normal, normal, x, normal, ipad)
#define TTAdaptedValueForScreen5(normal, ipad) TTAdaptedValueForScreen(normal, normal, normal, normal, ipad)

// 根绝设备屏幕自动选择对应的值
#define TTAdaptedValueForScreen(small, normal, x, plus, ipad) ({\
typeof(normal) constant = normal; \
CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds); \
CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds); \
CGFloat screenWidth = MIN(width, height); \
CGFloat screenHeight = MAX(width, height); \
if (screenWidth == 320) { \
constant = small; \
} else if ((screenWidth == 375 && screenHeight == 812) || (screenWidth == 414 && screenHeight == 896)) { \
constant = x; \
} else if (screenWidth == 412) { \
constant = plus; \
} else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { \
constant = ipad; \
} \
constant; \
})


#endif /* TTUIMacros_h */
