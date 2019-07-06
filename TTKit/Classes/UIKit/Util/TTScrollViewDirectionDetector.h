//
//  TTScrollViewDirectionDetector.h
//  OCTest
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTScrollViewDirectionDetector : NSObject

@property (nonatomic, assign) BOOL isDragging; // 是否正在拖拽

@property (nonatomic, assign) BOOL isDirectionPositive; // 向左或向上
@property (nonatomic, assign) CGFloat offsetInSameDirection; // 同向滚动距离
@property (nonatomic, assign) CGFloat draggingOffsetInSameDirection; // 拖拽的同向滚动距离

- (instancetype)initWithInitialContentOffset:(CGPoint)offset;

- (void)handleScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)beginDraggingScrollView:(UIScrollView *)scrollView;
- (void)endDraggingScrollView:(UIScrollView *)scrollView;

@end
