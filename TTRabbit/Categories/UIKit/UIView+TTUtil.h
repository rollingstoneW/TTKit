//
//  UIView+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TTUtil)

/**
 设置layer边框

 @param width 边框宽度
 @param color 边框颜色
 @param cornerRadius 圆角
 */
- (void)tt_setLayerBorder:(CGFloat)width color:(UIColor * _Nullable)color cornerRadius:(CGFloat)cornerRadius;

/**
 设置layer边框
 
 @param width 边框宽度
 @param color 边框颜色
 @param cornerRadius 圆角
 @param masksToBounds 是否需要设置mask
 */
- (void)tt_setLayerBorder:(CGFloat)width color:(UIColor * _Nullable)color cornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masksToBounds;

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
 设置某个方向的圆角。需要自身约束设置完整或者自身已经布局完成
 @param corners 方向
 @param cornerRadii 圆角大小
 */
- (void)tt_setLayerRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 设置某个方向的圆角
 @param corners 方向
 @param cornerRadii 圆角大小
 @param size 自身大小
 */
- (void)tt_setLayerRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii selfSize:(CGSize)size;

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
- (UIPanGestureRecognizer *)tt_addPanGestureWithTarget:(id)target selector:(SEL)selector;

/**
 添加滑动手势
 */
- (UISwipeGestureRecognizer *)tt_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction Target:(id)target selector:(SEL)selector;

/**
 添加长按手势
 */
- (UILongPressGestureRecognizer *)tt_addLongPressGestureWithTarget:(id)target selector:(SEL)selector;

/**
 添加点击手势
 */
- (UITapGestureRecognizer *)tt_addTapGestureWithBlock:(void(^)(UITapGestureRecognizer *tap))block;

/**
 添加拖动手势
 */
- (UIPanGestureRecognizer *)tt_addPanGestureWithBlock:(void(^)(UIPanGestureRecognizer *pan))block;

/**
 添加滑动手势
 */
- (UISwipeGestureRecognizer *)tt_addSwipeGestureWithDirection:(UISwipeGestureRecognizerDirection)direction block:(void(^)(UISwipeGestureRecognizer *swipe))block;

/**
 添加长按手势
 */
- (UILongPressGestureRecognizer *)tt_addLongPressGestureWithBlock:(void(^)(UILongPressGestureRecognizer *longPress))block;

/**
 移除所有手势
 */
- (void)tt_removeAllGesture;

/**
 所有子视图层级的描述
 */
- (NSString *)tt_debugHierarchy;

/**
 安全区域，iOS11之前是UIEdgeInsetsZero
 */
- (UIEdgeInsets)tt_safeAreaInsets;


/**
 找到指定约束的值
 @param attribute 指定约束的属性
 */
- (CGFloat)tt_layoutConstantForAttribute:(NSLayoutAttribute)attribute;

/**
 找到指定依赖于别的视图的约束的值
 @param attribute 指定约束的属性
 */
- (CGFloat)tt_layoutConstantForAttribute:(NSLayoutAttribute)attribute relatedView:(UIView *)view;

/**
 找到指定依赖于别的视图约束的约束的值
 @param attribute 指定约束的属性
 */
- (CGFloat)tt_layoutConstantForAttribute:(NSLayoutAttribute)attribute relatedView:(UIView *)view relatedAttribute:(NSLayoutAttribute)related;

/**
 监听size的变化
 @param change 接受新size的block
 */
- (void)tt_observesSizeDidChange:(void(^)(CGSize newSize))change;

@end

NS_ASSUME_NONNULL_END
