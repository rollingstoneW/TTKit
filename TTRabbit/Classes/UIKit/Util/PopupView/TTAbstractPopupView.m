//
//  TTAbstractPopupView.m
//  TTKit
//
//  Created by rollingstoneW on 2018/8/10.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTAbstractPopupView.h"
#import "TTAbstractPopupView+Internal.h"
#import <objc/runtime.h>

static const NSTimeInterval AnimationDuration = .25;
const TTPopupShowingPriority TTPopupShowingPriorityHigh = 100;
const TTPopupShowingPriority TTPopupShowingPriorityMedium = 50;
const TTPopupShowingPriority TTPopupShowingPriorityDefaultLow = 0;

@interface TTAbstractPopupView ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation TTAbstractPopupView

//- (void)dealloc {
//    NSLog(@"%@ %s", self, __func__);
//}

- (void)showInMainWindow {
    [self showInView:[[UIApplication sharedApplication].delegate window] animated:YES];
}

- (void)showInKeyWindow {
    [self showInView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    self.superviewToShowing = view;
    self.animated = animated;
    [self.popupMangager showPopupView:self inView:view animated:animated];
}

- (void)_showInView:(UIView *)view animated:(BOOL)animated {
    [view addSubview:self];
    self.containerView.frame = self.containerFrame;
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self willShow:animated];
    if (animated) {
        [self presentShowingAnimationWithCompletion:^{
            [self didShow:animated];
        }];
    } else {
        [self didShow:animated];
    }
}

- (void)dismissWithCompletion:(dispatch_block_t)completion animated:(BOOL)animated {
    [self willDismiss:animated];
    dispatch_block_t block = ^{
        [self removeFromSuperview];

        !self.dismissedBlock ?: self.dismissedBlock();
        [self didDismiss:animated];
        !completion ?: completion();

        self.dismissedBlock = nil;
        self.confirmedBlock = nil;
        self.cancelledBlock = nil;

        [self.popupMangager dismissedPopupView:self];
    };
    if (animated) {
        [self presentDismissingAnimationWithCompletion:^{
            block();
        }];
    } else {
        block();
    }
}

- (void)dismiss {
    [self dismissWithCompletion:nil animated:YES];
}

- (void)presentShowingAnimationWithCompletion:(dispatch_block_t)completion {
    self.alpha = 0;
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

- (void)presentDismissingAnimationWithCompletion:(dispatch_block_t)completion {
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        !completion ?: completion();
    }];
}

- (BOOL)shouldBeDismissedByPopupView:(__kindof TTAbstractPopupView *)popupView {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.dimBackground) {
        if (!self.tapDimToDismiss || event.allTouches.count != 1) {
            return;
        }
        UITouch *touch = touches.anyObject;
        if (!CGRectContainsPoint(self.containerView.frame, [touch locationInView:self])) {
            [self dismissWithCompletion:nil animated:self.animated];
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.dimBackground) {
        return [super pointInside:point withEvent:event];
    }
    return [self.containerView pointInside:[self convertPoint:point toView:self.containerView] withEvent:event];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self _setup];
    [self _loadSubviews];
}

- (void)_setup {
    self.showingPolicy = TTPopupShowingOnlyNoneExists;
    self.tapDimToDismiss = NO;
    self.dimBackground = YES;
    self.dismissWhenConfirm = YES;
    self.alpha = 0;
}

- (void)_loadSubviews {
    [self addSubview:self.containerView];
}

- (void)willShow:(BOOL)animated {}
- (void)didShow:(BOOL)animated {}
- (void)willDismiss:(BOOL)animated {}
- (void)didDismiss:(BOOL)animated {}

- (void)setDimBackground:(BOOL)dimBackground {
    _dimBackground = dimBackground;
    self.backgroundColor = dimBackground ? [[UIColor blackColor] colorWithAlphaComponent:.6] : [UIColor clearColor];
}

- (CGRect)containerFrame {
    if (CGRectIsEmpty(_containerFrame)) {
        CGFloat left = 20;
        CGFloat height = 100;
        return CGRectMake(left, (CGRectGetHeight(self.superview.bounds) - height) / 2, CGRectGetWidth(self.superview.bounds) - left * 2, height);
    }
    return _containerFrame;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _containerView;
}

- (TTPopupViewManager *)popupMangager {
    return _popupMangager ?: [TTPopupViewManager lazilyGlobleManager];
}

@end
