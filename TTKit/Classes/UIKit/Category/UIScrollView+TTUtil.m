//
//  UIScrollView+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/14.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIScrollView+TTUtil.h"
#import "TTMacros.h"

@implementation UIScrollView (TTUtil)

- (CGFloat)tt_contentTopByInset {
    return -self.tt_adjustedContentInset.top;
}

- (CGFloat)tt_contentLeftByInset {
    return -self.tt_adjustedContentInset.left;
}

- (CGFloat)tt_contentBottomByInset {
    return self.contentSize.height + self.tt_adjustedContentInset.bottom;
}

- (CGFloat)tt_contentRightByInset {
    return self.contentSize.width + self.tt_adjustedContentInset.right;
}

- (CGSize)tt_contentSizeByInset {
    CGSize contentSize = self.contentSize;
    contentSize.width += self.tt_adjustedContentInset.left + self.tt_adjustedContentInset.right;
    contentSize.height += self.tt_adjustedContentInset.top + self.tt_adjustedContentInset.bottom;
    return contentSize;
}

- (BOOL)tt_isAtTopByInset {
    return self.contentOffset.y == [self tt_contentTopByInset];
}

- (BOOL)tt_isAtLeftByInset {
    return self.contentOffset.x == [self tt_contentLeftByInset];
}

- (BOOL)tt_isAtBottomByInset {
    return self.contentOffset.y >= [self tt_contentBottomByInset] - self.bounds.size.height;
}

- (BOOL)tt_isAtRightByInset {
    return self.contentOffset.x >= [self tt_contentRightByInset] - self.bounds.size.width;
}

- (void)tt_scrollToTopByInset {
    [self tt_scrollToTopByInsetAnimated:YES];
}

- (void)tt_scrollToBottomByInset {
    [self tt_scrollToBottomByInsetAnimated:YES];
}

- (void)tt_scrollToLeftByInset {
    [self tt_scrollToLeftByInsetAnimated:YES];
}

- (void)tt_scrollToRightByInset {
    [self tt_scrollToRightByInsetAnimated:YES];
}

- (void)tt_scrollToTopByInsetAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.tt_adjustedContentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)tt_scrollToBottomByInsetAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.tt_adjustedContentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)tt_scrollToLeftByInsetAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.tt_adjustedContentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)tt_scrollToRightByInsetAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.tt_adjustedContentInset.right;
    [self setContentOffset:off animated:animated];
}

- (UIEdgeInsets)tt_adjustedContentInset {
    if (@available(iOS 11.0, *)) {
        return self.adjustedContentInset;
    } else {
        return self.contentInset;
    }
}

@end
