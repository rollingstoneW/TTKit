//
//  UIButton+TTTouchArea.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIButton+TTTouchArea.h"
#import <objc/runtime.h>

@implementation UIButton (TTTouchArea)

- (void)setTt_hitTestEdgeInsets:(UIEdgeInsets)tt_hitTestEdgeInsets {
    objc_setAssociatedObject(self, @selector(tt_hitTestEdgeInsets),
                             [NSValue valueWithUIEdgeInsets:tt_hitTestEdgeInsets],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tt_hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, @selector(tt_hitTestEdgeInsets));
    return value ? value.UIEdgeInsetsValue : UIEdgeInsetsZero;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.enabled || self.hidden || self.alpha <= 0.01) {
        return NO;
    }
    if(UIEdgeInsetsEqualToEdgeInsets(self.tt_hitTestEdgeInsets, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }

    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.tt_hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end
