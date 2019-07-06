//
//  UIWindow+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (TTUtil)

/**
 最上方的window
 */
+ (UIWindow *)tt_topWindow;

/**
 键盘所在window
 */
+ (UIWindow *)tt_keyboardWindow;

/**
 UI主window
 */
+ (UIWindow *)tt_mainWindow;

@end

NS_ASSUME_NONNULL_END
