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
 获取系统导航栏高度
 */
+ (NSInteger)tt_navigationBarHeight;

/**
 获取系统tabBar高度
 */
+ (NSInteger)tt_tabBarHeight;

@end

NS_ASSUME_NONNULL_END
