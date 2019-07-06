//
//  TTScrollViewDirectionDetector.m
//  OCTest
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTScrollViewDirectionDetector.h"

@implementation TTScrollViewDirectionDetector {
    CGPoint _lastContentOffset;
    CGPoint _lastTurningContentOffset;
    CGPoint _lastDraggingContentOffset;
}

- (instancetype)initWithInitialContentOffset:(CGPoint)offset {
    self = [super init];
    if (self) {
        _lastTurningContentOffset = offset;
        _lastContentOffset = offset;
    }
    return self;
}

- (void)beginDraggingScrollView:(UIScrollView *)scrollView {
    self.isDragging = YES;
    _lastDraggingContentOffset = scrollView.contentOffset;
}

- (void)handleScrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL isLeft = scrollView.contentOffset.x > _lastContentOffset.x;
    BOOL isUp = scrollView.contentOffset.y > _lastContentOffset.y;
    BOOL isDirectionPositive = isLeft || isUp;

    if (self.isDirectionPositive == isDirectionPositive) {
        if (isDirectionPositive) {
            self.offsetInSameDirection = isLeft ? scrollView.contentOffset.x - _lastContentOffset.x : scrollView.contentOffset.y - _lastContentOffset.y;
        } else {
            self.offsetInSameDirection = isLeft ? _lastContentOffset.x - scrollView.contentOffset.x : _lastContentOffset.y - scrollView.contentOffset.y;
        }
        if (self.isDragging) {
            if (isDirectionPositive) {
                self.draggingOffsetInSameDirection = isLeft ? scrollView.contentOffset.x - _lastDraggingContentOffset.x : scrollView.contentOffset.y - _lastDraggingContentOffset.y;
            } else {
                self.draggingOffsetInSameDirection = isLeft ? _lastDraggingContentOffset.x - scrollView.contentOffset.x : _lastDraggingContentOffset.y - scrollView.contentOffset.y;
            }
        }
    } else {
        self.offsetInSameDirection = 0;
        self.draggingOffsetInSameDirection = 0;
        _lastTurningContentOffset = scrollView.contentOffset;
    }

    self.isDirectionPositive = isDirectionPositive;
    _lastContentOffset = scrollView.contentOffset;
}

- (void)endDraggingScrollView:(id)scrollView {
    self.isDragging = NO;
    self.draggingOffsetInSameDirection = 0;
}

@end
