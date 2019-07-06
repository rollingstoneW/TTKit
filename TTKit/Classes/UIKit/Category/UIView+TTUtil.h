//
//  UIView+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TTUtil)


/**
 设置layer边框

 @param width 边框宽度
 @param color 边框颜色
 @param cornerRadius 圆角
 */
- (void)tt_setLayerBorder:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/**
 设置layer边框
 
 @param width 边框宽度
 @param color 边框颜色
 @param cornerRadius 圆角
 @param masksToBounds 是否需要设置mask
 */
- (void)tt_setLayerBorder:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masksToBounds;

/**
 设置layer阴影

 @param color 阴影颜色
 @param offset 阴影偏移量
 */
- (void)tt_setLayerShadow:(UIColor *)color offset:(CGSize)offset;

/**
 设置水平方向抗压缩和抗拉伸优先级
 */
- (void)tt_setContentHorizentalResistancePriority:(UILayoutPriority)priority;

/**
 设置竖直方向抗压缩和抗拉伸优先级
 */
- (void)tt_setContentVerticalResistancePriority:(UILayoutPriority)priority;

/**
 通过openGL截图
 */
- (UIImage *)tt_drawGlToImage;

/**
 通过系统方式截图
 */
- (UIImage *)tt_imageCaptureBySystem;

/**
 添加点击手势
 */
- (UITapGestureRecognizer *)tt_addTapGestureWithTarget:(id)target selector:(SEL)selector;

/**
 添加拖动手势
 */
- (UITapGestureRecognizer *)tt_addPanGestureWithTarget:(id)target selector:(SEL)selector;

/**
 添加长按手势
 */
- (UILongPressGestureRecognizer *)tt_addLongPressGestureWithTarget:(id)target selector:(SEL)selector;

/**
 移除所有手势
 */
- (void)tt_removeAllGesture;

@end
