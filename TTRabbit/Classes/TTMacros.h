//
//  TTMacros.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#ifndef TTMacros_h
#define TTMacros_h

#import <objc/runtime.h>

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
#define kStatusBarHeight                  (kCurrentStatusBarHeight ?: (DeviceIsFullScreen ? 44 : 20))
#define kNavigationBarBottom              (kStatusBarHeight + kNavigationBarHeight)
#define kTabBarHeight                     ([UIDevice tt_tabBarHeight] + kWindowSafeAreaBottom)
#define kWindowSafeAreaBottom             (@available(iOS 11.0, *) ? [[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom : 0)

#define kWidth_1px                        (1 / [UIScreen mainScreen].scale)
#define kMarginLeft                       15

#define kAppDelegate                      ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kMainWindow                       [[UIApplication sharedApplication].delegate window]
#define kKeyWindow                        [UIApplication sharedApplication].keyWindow
#define kIsLandccape                      UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)

#define ReplaceNaN(x)                     (x = isnan(x) ? 0 : x)
#define ReplaceNaNWithNumber(x,aNumber)   (x = isnan(x) ? aNumber : x)

#define NumberInRange(x, min, max)        MAX(MIN(max, x), min)
#define Number2NewIfNotFound(x, new)      (x == NSNotFound ? new : x)
#define Number2ZeroIfNotFound(x)          Number2NewIfNotFound(x, 0)

typedef void(^TTCompletionBlock)(__kindof id data, NSError *error);
#define kSafeBlock(block, ...)            (!block ?: block(__VA_ARGS__))

#define kSafePerformSelector(target, sel, ...) ([target respondsToSelector:sel] ? [target performSelectorWithArgs:sel, __VA_ARGS__] : nil)

// 去除Warc-performSelector-leaks警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0);

// 去除Wundeclared-selector警告
#define SuppressSelectorDeclaredWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0);

#pragma mark - Device
#define DeviceIsPad       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DeviceIsPhone     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断iPhoneX
#define DeviceIsIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !DeviceIsPad : NO)
//判断iPHoneXr
#define DeviceIsIphoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !DeviceIsPad : NO)
//判断iPhoneXs
#define DeviceIsIphoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !DeviceIsPad : NO)
//判断iPhoneXs Max
#define DeviceIsIphoneXS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !DeviceIsPad : NO)
//判断是否为全面屏
#define DeviceIsFullScreen (DeviceIsIphoneX == YES || DeviceIsIphoneXR == YES || DeviceIsIphoneXS == YES || DeviceIsIphoneXS_MAX == YES)

#pragma mark - System Version

#define IOS_2_0 @"2.0"
#define IOS_3_0 @"3.0"
#define IOS_4_0 @"4.0"
#define IOS_5_0 @"5.0"
#define IOS_6_0 @"6.0"
#define IOS_7_0 @"7.0"
#define IOS_8_0 @"8.0"
#define IOS_9_0 @"9.0"
#define IOS_10_0 @"10.0"
#define IOS_11_0 @"11.0"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOS8Later @available(iOS 8.0, *)
#define iOS9Later @available(iOS 9.0, *)
#define iOS10Later @available(iOS 10.0, *)
#define iOS11Later @available(iOS 11.0, *)
#define iOS12Later @available(iOS 12.0, *)
#define iOS13Later @available(iOS 13.0, *)

#pragma mark - UIAdapter

#define kAdaptedWidth4(width)             (width * (kScreenWidth / 320))
#define kAdaptedWidth47(width)            (width * (kScreenWidth / 375))
#define k1dot5ValueOniPad(value) kAdaptedValueForScreen5(value, value * 1.5)

#define kAdaptedValueForScreen1(small, normal) kAdaptedValueForScreen(small, normal, normal, normal, normal)
#define kAdaptedValueForScreen2(small, normal, x) kAdaptedValueForScreen(small, normal, x, normal, normal)
#define kAdaptedValueForScreen6(small, normal, ipad) kAdaptedValueForScreen(small, normal, normal, normal, ipad)
#define kAdaptedValueForScreen3(small, normal, x, ipad) kAdaptedValueForScreen(small, normal, x, normal, ipad)
#define kAdaptedValueForScreen4(normal, x, ipad) kAdaptedValueForScreen(normal, normal, x, normal, ipad)
#define kAdaptedValueForScreen5(normal, ipad) kAdaptedValueForScreen(normal, normal, normal, normal, ipad)

// 根绝设备屏幕自动选择对应的值
#define kAdaptedValueForScreen(small, normal, x, plus, ipad) ({\
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

#pragma mark - Setter && Getter

#define kSetterCondition(NAME, ...) if (_##NAME == NAME) { \
return; \
}\
{__VA_ARGS__; }\
_##NAME = NAME;

#define kSetterEqualCondition(NAME, SEL, ...) if ([_##NAME SEL:NAME]) { \
return; \
}\
{__VA_ARGS__; }\
_##NAME = NAME;

#define kGetterIMP(TYPE, NAME, ...) - (TYPE)NAME { \
if (!_##NAME) { \
_##NAME = __VA_ARGS__; \
} \
return _##NAME; \
}

#define kGetterObjectIMP(NAME, ...) kGetterIMP(id, NAME, __VA_ARGS__)
#define kCapitalizeFirstChar(aString) if (aString.length) { \
return  [aString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[aString substringToIndex:1] capitalizedString]]; \
} else { \
return nil; \
}

#define TTSYNTH_DYNAMIC_PROPERTY_BOOLVALUE(_getter_, _setter_, _defaultValue_) \
- (void)_setter_ : (BOOL)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, @selector(_getter_), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (BOOL)_getter_ { \
NSNumber *value = objc_getAssociatedObject(self, @selector(_getter_)); \
if (!value && _defaultValue_) { \
value = @(_defaultValue_); \
[self _setter_:value]; \
} \
return value.boolValue; \
}

#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE2(_getter_, _setter_, _type_, _defaultValue_) TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _type_, _defaultValue_)
#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE3(_getter_, _setter_, _type_, _selector_) TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _selector_, 0)
#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE4(_getter_, _setter_, _type_) TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _type_, 0)

#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _selector_, _defaultValue_) \
- (void)_setter_:(_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, @selector(_getter_), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
NSNumber *value = objc_getAssociatedObject(self, _cmd); \
if (!value && _defaultValue_) { \
value = @(_defaultValue_); \
[self _setter_:_defaultValue_]; \
} \
return value._selector_; \
}

#endif /* TTMacros_h */
