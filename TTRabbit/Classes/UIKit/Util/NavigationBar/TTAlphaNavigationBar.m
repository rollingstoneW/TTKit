//
//  TTAlphaNavigationBar.m
//  TTKit
//
//  Created by rollingstoneW on 2018/9/18.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTAlphaNavigationBar.h"
#import "TTMacros.h"
#import "UIColor+YYAdd.h"

const UIControlState TTNavigationBarClearState = UIControlStateSelected;

@implementation TTAlphaNavigationBar

- (void)initializer {
    [super initializer];

    self.isBackgroundClear = NO;
    self.showTitleWhenBackgroundClear = NO;
    self.shadowLine.backgroundColor = [UIColor clearColor];
}

- (void)handleScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= self.offsetYToChangeAlpha && self.isBackgroundClear) {
        [self setIsBackgroundClear:NO animated:YES];
    } else if (offsetY < self.offsetYToChangeAlpha && !self.isBackgroundClear) {
        [self setIsBackgroundClear:YES animated:YES];
    }
}

- (void)setIsBackgroundClear:(BOOL)isBackgroundClear {
    [self setIsBackgroundClear:isBackgroundClear animated:NO];
}

- (void)setIsBackgroundClear:(BOOL)isBackgroundClear animated:(BOOL)animated {
    kSetterCondition(isBackgroundClear);

    if (animated) {
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        [self.layer addAnimation:transition forKey:nil];
    }

    NSArray *buttons = [self.leftButtons arrayByAddingObjectsFromArray:self.rightButtons];
    UIView *bgView = self.subviews.firstObject;

    if (isBackgroundClear) {
        [buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            obj.selected = YES;
        }];
        self.titleAttributes = @{NSForegroundColorAttributeName:self.showTitleWhenBackgroundClear ? [UIColor whiteColor] : [UIColor clearColor]};
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.contents = nil;
        self.shadowLine.hidden = YES;
    } else {
        [buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            obj.selected = NO;
        }];
        self.titleAttributes = @{NSForegroundColorAttributeName:UIColorHex(333333)};
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.contents = (id)self.backgroundImage.CGImage;
        self.shadowLine.hidden = NO;
    }

    [self updateStatusBarStyleIfNeeded];
}

- (void)setAutoAdjustStatusBarStyle:(BOOL)autoAdjustStatusBarStyle {
    kSetterCondition(autoAdjustStatusBarStyle);
    [self updateStatusBarStyleIfNeeded];
}

- (void)updateStatusBarStyleIfNeeded {
    if (!self.autoAdjustStatusBarStyle) {
        return;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:self.isBackgroundClear ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault
                                                animated:YES];
}

@end
