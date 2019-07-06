//
//  UHArrowLabel.m
//  Uhouzz
//
//  Created by 韦振宁 on 16/7/1.
//  Copyright © 2016年 Uhouzz. All rights reserved.
//

#import "UHArrowLabel.h"

@interface UHArrowLabel ()

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end

@implementation UHArrowLabel

- (void) showAddedToView:(UIView *)view {
    self.layer.mask = self.maskLayer;
    [view addSubview:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.userInteractionEnabled = YES;
    self.numberOfLines = 0;
    self.textAlignment = NSTextAlignmentCenter;
    _textDistanceToBorder = 5.f;
    _cornerRadius = 5.f;
    _arrowHeight = 10.f;
    _arrowWidth = 20.f;
    _arrowJoinCornerRadius = 3.f;
}

- (void) drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets)];
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize targetSize = [super intrinsicContentSize];
    
    targetSize.width  += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    targetSize.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    
    return targetSize;
}

- (CGSize) intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    
    size.width  += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    size.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    
    return size;
}

- (UIEdgeInsets) contentEdgeInsets {
    BOOL isDirectionTop = self.direction == UHArrowLabelDirectionTop;
    CGFloat top = isDirectionTop ? self.arrowHeight + self.textDistanceToBorder : self.textDistanceToBorder;
    CGFloat bottom = isDirectionTop ? self.textDistanceToBorder : self.arrowHeight + self.textDistanceToBorder;
    return UIEdgeInsetsMake( top, self.textDistanceToBorder, bottom, self.textDistanceToBorder);
}

- (CAShapeLayer *) maskLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowRadius = 5;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat marginTop = self.contentEdgeInsets.top - self.textDistanceToBorder;
    CGFloat marginBottom = self.contentEdgeInsets.bottom - self.textDistanceToBorder;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, height - self.cornerRadius );
    CGPathAddLineToPoint(path, NULL, 0, marginTop + self.cornerRadius);
    CGPathAddArc(path, NULL, self.cornerRadius, marginTop + self.cornerRadius, self.cornerRadius, M_PI, M_PI_2 * 3, NO);
    
    if (self.direction == UHArrowLabelDirectionTop) {
        CGPathAddLineToPoint(path, NULL, self.arrowMarginLeft, marginTop);
        CGPathAddLineToPoint(path, NULL, self.arrowMarginLeft + self.arrowWidth / 2, 0.f);
        CGPathAddLineToPoint(path, NULL, self.arrowMarginLeft + self.arrowWidth, marginTop);
        CGPathAddLineToPoint(path, NULL, width - self.cornerRadius, marginTop);
        CGPathAddArc(path, NULL, width - self.cornerRadius, marginTop + self.cornerRadius, self.cornerRadius, -M_PI_2, 0, NO);
    } else {
        CGPathAddLineToPoint(path, NULL, width - self.cornerRadius, marginTop);
        CGPathAddArc(path, NULL, width - self.cornerRadius, marginTop + self.cornerRadius, self.cornerRadius, -M_PI_2, 0, NO);
    }
    
    CGPathAddLineToPoint(path, NULL, width, height - marginBottom - self.cornerRadius);
    CGPathAddArc(path, NULL, width - self.cornerRadius, height - marginBottom - self.cornerRadius, self.cornerRadius, 0, M_PI_2, NO);
    
    if (self.direction == UHArrowLabelDirectionBottom) {
        CGPathAddLineToPoint(path, NULL, self.arrowMarginLeft + self.arrowWidth, height - marginBottom);
        CGPathAddLineToPoint(path, NULL, self.arrowMarginLeft + self.arrowWidth / 2, height);
        CGPathAddLineToPoint(path, NULL, self.arrowMarginLeft, height - marginBottom);
        CGPathAddLineToPoint(path, NULL, self.cornerRadius, height - marginBottom);
        CGPathAddArc(path, NULL, self.cornerRadius, height - marginBottom - self.cornerRadius, self.cornerRadius, M_PI_2, M_PI, NO);
    } else  {
        CGPathAddLineToPoint(path, NULL, self.cornerRadius, height - marginBottom);
        CGPathAddArc(path, NULL, self.cornerRadius, height - marginBottom - self.cornerRadius, self.cornerRadius, M_PI_2, M_PI, NO);
    }
    
    
    CGPathCloseSubpath(path);
    layer.path = path;
    CGPathRelease(path);
    
    return layer;
}

@end
