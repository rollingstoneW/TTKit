//
//  NSBundle+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (TTUtil)

/**
 app桌面图标
 */
+ (UIImage * _Nullable)tt_appIcon;

/**
 可更换的app图标名称
 */
+ (NSArray * _Nullable)tt_alternateIconNames;

/**
 当前更换的app图标名称
 */
+ (NSString * _Nullable)tt_alternateIconName;

/**
 更换app图标

 @param alternateIconName 传空设置为默认的app图标
 @param completionHandler 完成的回掉
 */
+ (void)tt_setAlternateIconName:(NSString * _Nullable)alternateIconName completionHandler:(nullable void (^)(NSError *_Nullable error))completionHandler;

/**
 app当前设备竖屏启动图
 */
+ (UIImage * _Nullable)tt_launchImage;

/**
 app版本
 */
+ (NSString *)tt_appVersion;

/**
 app名称
 */
+ (NSString *)tt_appDisplayName;

/**
 打开系统设置页面
 */
+ (void)tt_openSystemSetting;


/**
 app是否时第一次安装
 */
+ (BOOL)tt_appIsFirstInstall;

/**
 设置为不是第一次安装
 */
+ (void)tt_unsetAppIsFirstInstall;

/**
 根据bundle名称获取bundle

 @param name bundle名称
 */
+ (instancetype _Nullable)tt_bundleWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
