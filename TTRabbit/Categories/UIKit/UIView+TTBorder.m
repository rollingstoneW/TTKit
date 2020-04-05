//
//  UIView+TTBorder.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIView+TTBorder.h"

@implementation UIView (TTBorder)

#define kWidth_1px 1 / [UIScreen mainScreen].scale

- (UIView *)tt_add1pxTopBorderWithColor:(UIColor *)color {
    return [self tt_addBordersAtEdge:TTViewEdgeTop width:kWidth_1px color:color insets:UIEdgeInsetsZero].firstObject;
}

- (UIView *)tt_add1pxLeftBorderWithColor:(UIColor *)color {
    return [self tt_addBordersAtEdge:TTViewEdgeLeft width:kWidth_1px color:color insets:UIEdgeInsetsZero].firstObject;
}

- (UIView *)tt_add1pxBottomBorderWithColor:(UIColor *)color {
    return [self tt_addBordersAtEdge:TTViewEdgeBottom width:kWidth_1px color:color insets:UIEdgeInsetsZero].firstObject;
}

- (UIView *)tt_add1pxRightBorderWithColor:(UIColor *)color {
    return [self tt_addBordersAtEdge:TTViewEdgeRight width:kWidth_1px color:color insets:UIEdgeInsetsZero].firstObject;
}

#undef kWidth_1px

- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge width:(CGFloat)width color:(UIColor *)color {
    return [self tt_addBordersAtEdge:edge width:width color:color leading:0 inset:0];
}

- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge width:(CGFloat)width color:(UIColor *)color leading:(CGFloat)leading {
    return [self tt_addBordersAtEdge:edge width:width color:color leading:leading inset:0];
}

- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge
                                     width:(CGFloat)width
                                     color:(UIColor *)color
                                   leading:(CGFloat)leading
                                     inset:(CGFloat)inset {
    NSMutableArray *borders = [NSMutableArray array];
    if (edge & TTViewEdgeTop) {
        NSArray *rets = [self tt_addBordersAtEdge:TTViewEdgeTop width:width color:color insets:UIEdgeInsetsMake(leading, inset, 0, inset)];
        [borders addObject:rets.firstObject];
    }
    if (edge & TTViewEdgeLeft) {
        NSArray *rets = [self tt_addBordersAtEdge:TTViewEdgeLeft width:width color:color insets:UIEdgeInsetsMake(inset, leading, inset, 0)];
        [borders addObject:rets.firstObject];
    }
    if (edge & TTViewEdgeBottom) {
        NSArray *rets = [self tt_addBordersAtEdge:TTViewEdgeBottom width:width color:color insets:UIEdgeInsetsMake(0, inset, leading, inset)];
        [borders addObject:rets.firstObject];
    }
    if (edge & TTViewEdgeRight) {
        NSArray *rets = [self tt_addBordersAtEdge:TTViewEdgeRight width:width color:color insets:UIEdgeInsetsMake(inset, 0, inset, leading)];
        [borders addObject:rets.firstObject];
    }

    return borders;
}

- (NSArray<UIView *> *)tt_addBordersAtEdge:(TTViewEdge)edge width:(CGFloat)width color:(UIColor *)color insets:(UIEdgeInsets)insets {

    NSMutableArray *borders = [NSMutableArray array];
    NSMutableArray *constraints = [NSMutableArray array];

    UIView *(^addBorder)(UIColor *color) = ^UIView *(UIColor *color) {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = color;
        [self addSubview:view];
        [borders addObject:view];
        return view;
    };

    if (edge & TTViewEdgeTop) {
        UIView *border = addBorder(color);
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeTop leading:insets.top]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeLeft leading:insets.left]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeRight leading:-insets.right]];
        [constraints addObject:[self tt_widthConstraintWithItem:border width:width isWidth:NO]];
    }
    if (edge & TTViewEdgeLeft) {
        UIView *border = addBorder(color);
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeTop leading:insets.top]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeLeft leading:insets.left]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeBottom leading:-insets.bottom]];
        [constraints addObject:[self tt_widthConstraintWithItem:border width:width isWidth:YES]];
    }
    if (edge & TTViewEdgeBottom) {
        UIView *border = addBorder(color);
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeBottom leading:-insets.bottom]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeLeft leading:insets.left]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeRight leading:-insets.right]];
        [constraints addObject:[self tt_widthConstraintWithItem:border width:width isWidth:NO]];
    }
    if (edge & TTViewEdgeRight) {
        UIView *border = addBorder(color);
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeTop leading:insets.top]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeBottom leading:-insets.bottom]];
        [constraints addObject:[self tt_edgeConstraintWithItem:border attribute:NSLayoutAttributeRight leading:-insets.right]];
        [constraints addObject:[self tt_widthConstraintWithItem:border width:width isWidth:YES]];
    }

    if ([NSLayoutConstraint respondsToSelector:@selector(activateConstraints:)]) {
        [NSLayoutConstraint activateConstraints:constraints];
    } else {
        [self addConstraints:constraints];
    }

    return borders;
}

- (NSLayoutConstraint *)tt_edgeConstraintWithItem:(UIView *)item attribute:(NSLayoutAttribute)attribute leading:(CGFloat)leading {
    return [NSLayoutConstraint constraintWithItem:item
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1
                                         constant:leading];
}

- (NSLayoutConstraint *)tt_widthConstraintWithItem:(UIView *)item width:(CGFloat)width isWidth:(BOOL)isWidth {
    NSLayoutAttribute attribute = isWidth ? NSLayoutAttributeWidth : NSLayoutAttributeHeight;
    return [NSLayoutConstraint constraintWithItem:item
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1
                                         constant:width];
}

@end
