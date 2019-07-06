//
//  UIScrollView+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/14.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TTUtil)

/**
 滚动到最顶部的偏移量y
 */
- (CGFloat)tt_contentTopByInset;

/**
 滚动到最左边的偏移量x
 */
- (CGFloat)tt_contentLeftByInset;

/**
 滚动到最底部的偏移量y
 */
- (CGFloat)tt_contentBottomByInset;

/**
 滚动到最右边的偏移量x
 */
- (CGFloat)tt_contentRightByInset;

/**
 contentSize加上缩紧后的总大小
 */
- (CGSize)tt_contentSizeByInset;

/**
 是否停在最顶部
 */
- (BOOL)tt_isAtTopByInset;

/**
 是否停在最左边
 */
- (BOOL)tt_isAtLeftByInset;

/**
 是否停在最底部
 */
- (BOOL)tt_isAtBottomByInset;

/**
 是否停在最右边
 */
- (BOOL)tt_isAtRightByInset;

/**
 滚动到最顶部，默认需要动画
 animated 是否需要动画
 */
- (void)tt_scrollToTopByInset;
- (void)tt_scrollToTopByInsetAnimated:(BOOL)animated;

/**
 滚动到最底部，默认需要动画
 animated 是否需要动画
 */
- (void)tt_scrollToBottomByInset;
- (void)tt_scrollToBottomByInsetAnimated:(BOOL)animated;

/**
 滚动到最左边，默认需要动画
 animated 是否需要动画
 */
- (void)tt_scrollToLeftByInset;
- (void)tt_scrollToLeftByInsetAnimated:(BOOL)animated;

/**
 滚动到最右边，默认需要动画
 animated 是否需要动画
 */
- (void)tt_scrollToRightByInset;
- (void)tt_scrollToRightByInsetAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
