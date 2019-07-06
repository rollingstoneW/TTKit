//
//  UIButton+TTActionThrottle.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/27.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIButton+TTActionThrottle.h"
#import <objc/runtime.h>

NSTimeInterval const TTButtonActionThrottleUsePreferThreshold = -1;

@interface UIButton (TTPrivate)
@property (nonatomic, assign) NSTimeInterval tt_lastActionTime;
@end

@implementation UIButton (TTActionThrottle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(sendAction:to:forEvent:);
        SEL newSel = @selector(tt_sendAction:to:forEvent:);
        Method oldMethod = class_getInstanceMethod(self, oldSel);
        Method newMethod = class_getInstanceMethod(self, newSel);

        BOOL isAdd = class_addMethod(self, oldSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (isAdd) {
            class_replaceMethod(self, newSel, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }else{
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}

- (void)tt_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (![self isKindOfClass:[UIButton class]] || !self.tt_threshold) {
        [self tt_sendAction:action to:target forEvent:event];
        return;
    }
    NSTimeInterval now = CACurrentMediaTime();
    if(self.tt_lastActionTime && now - self.tt_lastActionTime < self.tt_threshold) {
        return;
    }
    [self tt_sendAction:action to:target forEvent:event];
    self.tt_lastActionTime = now;
}

+ (NSTimeInterval)tt_prefersThreshold {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

+ (void)setTt_prefersThreshold:(NSTimeInterval)tt_prefersThreshold {
    objc_setAssociatedObject(self, @selector(tt_prefersThreshold), @(tt_prefersThreshold), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)tt_threshold {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = @(TTButtonActionThrottleUsePreferThreshold);
    }
    if (number.doubleValue == TTButtonActionThrottleUsePreferThreshold) {
        return [self class].tt_prefersThreshold;
    }
    return number.doubleValue;
}

- (void)setTt_threshold:(NSTimeInterval)tt_threshold {
    objc_setAssociatedObject(self, @selector(tt_threshold), @(tt_threshold), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)tt_lastActionTime {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTt_lastActionTime:(NSTimeInterval)tt_lastActionTime {
    objc_setAssociatedObject(self, @selector(tt_lastActionTime), @(tt_lastActionTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
