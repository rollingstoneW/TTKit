//
//  UIButton+TTIndicator.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIButton+TTIndicator.h"
#import <objc/runtime.h>

const CGFloat TTIndicatorAutoDimension = 0;

@interface UIButton (TTPrivate)

@property (nonatomic, strong) UIActivityIndicatorView *tt_indicator;

@end

@implementation UIButton (TTIndicator)

- (void)tt_showWhiteIndicator {
    [self tt_showIndicatorWithStyle:UIActivityIndicatorViewStyleWhite size:TTIndicatorAutoDimension];
}

- (void)tt_showWhiteLargeIndicator {
    [self tt_showIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge size:TTIndicatorAutoDimension];
}

- (void)tt_showGrayIndicator {
    [self tt_showIndicatorWithStyle:UIActivityIndicatorViewStyleGray size:TTIndicatorAutoDimension];
}

- (void)tt_showIndicatorWithColor:(UIColor *)color size:(CGFloat)size {
    [self tt_cleanIndicator];

    self.tt_indicator = [[UIActivityIndicatorView alloc] init];
    self.tt_indicator.color = color;
    [self tt_setupIndicatorSize:size];
    [self tt_showIndicator];
}

- (void)tt_showIndicatorWithStyle:(UIActivityIndicatorViewStyle)style size:(CGFloat)size {
    [self tt_cleanIndicator];

    self.tt_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [self tt_setupIndicatorSize:size];
    [self tt_showIndicator];
}

- (void)tt_cleanIndicator {
    [self.tt_indicator stopAnimating];
    [self.tt_indicator removeFromSuperview];
    self.tt_indicator = nil;

    self.titleLabel.alpha = self.imageView.alpha = 1;
}

- (void)tt_setupIndicatorSize:(CGFloat)size {
    if (size == TTIndicatorAutoDimension) {
        return;
    }
    CGFloat width = [self.tt_indicator intrinsicContentSize].width;
    CGFloat scale = size / width;
    self.tt_indicator.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)tt_showIndicator {
    self.titleLabel.alpha = self.imageView.alpha = 0;

    [self addSubview:self.tt_indicator];
    self.tt_indicator.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.tt_indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.tt_indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraints:@[centerX, centerY]];

    [self.tt_indicator startAnimating];
    self.userInteractionEnabled = NO;
}

- (void)tt_hideIndicator {
    [self tt_cleanIndicator];
    self.userInteractionEnabled = YES;
}

- (UIActivityIndicatorView *)tt_indicator {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTt_indicator:(UIActivityIndicatorView *)tt_indicator {
    objc_setAssociatedObject(self, @selector(tt_indicator), tt_indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
