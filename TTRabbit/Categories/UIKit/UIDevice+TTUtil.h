//
//  UIDevice+TTUtil.h
//  TTKit
//
//  TTKit on 2019/6/11.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (TTUtil)

/**
 状态栏高度
*/
+ (CGFloat)tt_statusBarHeight;

/**
 获取系统导航栏高度
 */
+ (CGFloat)tt_navigationBarHeight;

/**
 获取系统导航栏底部
 */
+ (CGFloat)tt_navigationBarBottom;

/**
 获取系统tabBar高度
 */
+ (CGFloat)tt_tabBarHeight;

/**
 安全区域下面的高度
 */
+ (CGFloat)tt_safeAreaBottom;

/**
 是否是全面屏
 */
+ (BOOL)tt_isFullScreen;

@end

NS_ASSUME_NONNULL_END
