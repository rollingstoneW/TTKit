//
//  UIView+TTBorder.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TTViewEdge) {
    TTViewEdgeTop = 1 << 0,
    TTViewEdgeLeft = 1 << 1,
    TTViewEdgeBottom = 1 << 2,
    TTViewEdgeRight = 1 << 3,
    TTViewEdgeAll = TTViewEdgeTop | TTViewEdgeLeft | TTViewEdgeBottom | TTViewEdgeRight
};

@interface UIView (TTBorder)

/**
 添加1像素边界线
 */
- (UIView *)tt_add1pxTopBorderWithColor:(UIColor *)color;
- (UIView *)tt_add1pxLeftBorderWithColor:(UIColor *)color;
- (UIView *)tt_add1pxBottomBorderWithColor:(UIColor *)color;
- (UIView *)tt_add1pxRightBorderWithColor:(UIColor *)color;


/**
 添加边界线

 @param edge 边缘
 @param width 宽度
 @param color 颜色
 @return 添加的线，依次是上左下右的线
 */
- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge width:(CGFloat)width color:(UIColor *)color;

/**
 添加边界线

 @param edge 边缘
 @param width 宽度
 @param color 颜色
 @param leading 边界线距边界距离
 @return 添加的线，依次是上左下右的线
 */
- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge width:(CGFloat)width color:(UIColor *)color leading:(CGFloat)leading;

/**
 添加边界线

 @param edge 边缘
 @param width 宽度
 @param color 颜色
 @param leading 边界线距边界距离
 @param inset 边界线两端距边界距离
 @return 添加的线，依次是上左下右的线
 */
- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge width:(CGFloat)width color:(UIColor *)color leading:(CGFloat)leading inset:(CGFloat)inset;

/**
 添加边界线，且各个线是首尾互联的

 @param edge 边缘
 @param width 宽度
 @param color 颜色
 @param insets 各个方向的边界线分别距离边界的距离
 @return 添加的线，依次是上左下右的线
 */
- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge width:(CGFloat)width color:(UIColor *)color insets:(UIEdgeInsets)insets;

@end
