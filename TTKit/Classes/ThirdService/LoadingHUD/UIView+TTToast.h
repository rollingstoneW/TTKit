//
//  UIView+TTToast.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/5.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TTToast)

/**
 展示loading加载指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)showLoadingToast:(NSString * _Nullable)toast;
- (__kindof UIView *)showLoadingToast:(NSString * _Nullable)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示错误指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)showErrorToast:(NSString *)toast;
- (__kindof UIView *)showErrorToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示成功指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)showSuccessToast:(NSString *)toast;
- (__kindof UIView *)showSuccessToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示警告指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)showWarningToast:(NSString *)toast;
- (__kindof UIView *)showWarningToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示文字提示
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)showTextToast:(NSString *)toast;
- (__kindof UIView *)showTextToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

- (void)hideToasts;

@end

NS_ASSUME_NONNULL_END
