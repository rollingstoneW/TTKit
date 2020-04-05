//
//  UIButton+TTIndicator.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

// 加载指示器自适应大小
FOUNDATION_EXTERN const CGFloat TTIndicatorAutoDimension;

@interface UIButton (TTIndicator)

/**
 展示白色加载指示器
 */
- (void)tt_showWhiteIndicator;

/**
 展示白色大的加载指示器
 */
- (void)tt_showWhiteLargeIndicator;

/**
 展示灰色加载指示器
 */
- (void)tt_showGrayIndicator;

/**
 展示加载指示器

 @param color 颜色
 @param size 大小
 */
- (void)tt_showIndicatorWithColor:(UIColor *)color size:(CGFloat)size;

/**
 展示加载指示器
 
 @param style 类型
 @param size 大小
 */
- (void)tt_showIndicatorWithStyle:(UIActivityIndicatorViewStyle)style size:(CGFloat)size;

/**
 隐藏加载指示器
 */
- (void)tt_hideIndicator;

@end
