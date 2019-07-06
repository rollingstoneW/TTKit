//
//  TTPageControl.m
//  TTKit
//
//  Created by rollingstoneW on 2018/8/24.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTPageControl.h"

@implementation TTPageControl

- (instancetype)init {
    self = [super init];
    if (self) {
        _indicatorSize = CGSizeMake(5, 5);
        _currentIndicatorSize = CGSizeZero;
        _indicatorSpace = 5;
        _currentIndicatorSpace = 0;
        _indicatorCornerRadius = -1;
        _currentIndicatorCornerRadius = -1;
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];

    NSString *time;
    NSLayoutConstraint *titleAndTimeDistance;
    UIView *titleAndTimeSuperview; //title和time共同的父视图
    if (time.length && ![[titleAndTimeSuperview constraints] containsObject:titleAndTimeDistance]) {
        [titleAndTimeSuperview addConstraint:titleAndTimeDistance]; //如果没有这个约束就添加
    } else if (!time.length && [[titleAndTimeSuperview constraints] containsObject:titleAndTimeDistance]) {
        [titleAndTimeSuperview removeConstraint:titleAndTimeDistance]; //如果有这个约束就移除
    }

    CGFloat contentHeight = MAX(self.indicatorSize.height, self.currentIndicatorSize.height);
    CGFloat lastLeft = 0;
    for (NSInteger i = 0; i < layer.sublayers.count; i++) {
        CALayer *sublayer = layer.sublayers[i];
        if (i == self.currentPage) {
            sublayer.frame = CGRectMake(lastLeft,
                                        (contentHeight - self.currentIndicatorSize.height) / 2,
                                        self.currentIndicatorSize.width,
                                        self.currentIndicatorSize.height);
            sublayer.cornerRadius = self.currentIndicatorCornerRadius;
            lastLeft = CGRectGetMaxX(sublayer.frame) + self.currentIndicatorSpace;
        } else {
            sublayer.frame = CGRectMake(lastLeft,
                                        (contentHeight - self.indicatorSize.height) / 2,
                                        self.indicatorSize.width,
                                        self.indicatorSize.height);
            sublayer.cornerRadius = self.indicatorCornerRadius;
            lastLeft = CGRectGetMaxX(sublayer.frame) + (i + 1 == self.currentPage ? self.currentIndicatorSpace : self.indicatorSpace);
        }
    }

    if (self.layoutSublayersOverride) {
        self.layoutSublayersOverride(layer);
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    CALayer *lastSelectedLayer = [self.layer.sublayers objectAtIndex:self.currentPage];
    [super setCurrentPage:currentPage];
    CALayer *selectedLayer = [self.layer.sublayers objectAtIndex:currentPage];
    if (self.updateCurrentPage) {
        self.updateCurrentPage(selectedLayer, lastSelectedLayer);
    }
}

- (CGSize)intrinsicContentSize {
    NSInteger spaceNum = self.numberOfPages - 1 - 2;
    NSInteger currentSpaceNum = self.numberOfPages > 2 ? 2 : (self.numberOfPages == 1 ? 0 : 1);
    NSInteger unselectedIndicatorNum = (self.numberOfPages - 1);
    return CGSizeMake(self.indicatorSize.width * MAX(0, unselectedIndicatorNum) + MAX(0, spaceNum) * self.indicatorSpace + self.currentIndicatorSpace * currentSpaceNum + self.currentIndicatorSize.width, MAX(self.indicatorSize.height, self.currentIndicatorSize.height));
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)currentIndicatorSize {
    if (CGSizeEqualToSize(_currentIndicatorSize, CGSizeZero)) {
        return self.indicatorSize;
    }
    return _currentIndicatorSize;
}

- (CGFloat)currentIndicatorSpace {
    if (!_currentIndicatorSpace) {
        return self.indicatorSpace;
    }
    return _currentIndicatorSpace;
}

- (CGFloat)indicatorCornerRadius {
    if (_indicatorCornerRadius < 0) {
        return self.currentIndicatorSize.height / 2;
    }
    return _indicatorCornerRadius;
}

- (CGFloat)currentIndicatorCornerRadius {
    if (_currentIndicatorCornerRadius < 0) {
        return self.indicatorCornerRadius;
    }
    return _currentIndicatorCornerRadius;
}

@end
