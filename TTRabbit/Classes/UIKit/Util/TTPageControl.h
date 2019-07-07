//
//  TTPageControl.h
//  TTKit
//
//  Created by rollingstoneW on 2018/8/24.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TTPageControlLayoutSublayersOverride)(CALayer *layer);
typedef void(^TTPageControlUpdateCurrentPage)(CALayer *selectedIndicator, CALayer *lastSelectedIndicator);

@interface TTPageControl : UIPageControl

@property (nonatomic, assign) CGSize  indicatorSize; // {5,5}
@property (nonatomic, assign) CGSize  currentIndicatorSize; // same as indicatorSize
@property (nonatomic, assign) CGFloat indicatorSpace; // 5
@property (nonatomic, assign) CGFloat currentIndicatorSpace; // same as indicatorSpace
@property (nonatomic, assign) CGFloat indicatorCornerRadius; // indicatorSize.height / 2
@property (nonatomic, assign) CGFloat currentIndicatorCornerRadius; // same as indicatorCornerRadius

@property (nonatomic, copy) TTPageControlLayoutSublayersOverride layoutSublayersOverride;
@property (nonatomic, copy) TTPageControlUpdateCurrentPage updateCurrentPage;

@end
