//
//  TTSubviewTouchReceivableView.m
//  TTKit
//
//  Created by rollingstoneW on 2018/10/9.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTSubviewTouchReceivableView.h"

@implementation TTSubviewTouchReceivableView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if (subview.hidden || !subview.userInteractionEnabled || subview.alpha <= 0.01) {
            continue;
        }
        CGPoint subPoint = [self convertPoint:point toView:subview];
        if ([subview pointInside:subPoint withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

@end
