//
//  UHArrowLabel.h
//  Uhouzz
//
//  Created by 韦振宁 on 16/7/1.
//  Copyright © 2016年 Uhouzz. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kArrowMarginLeftToAlignmentCenter = 0.f;

typedef NS_ENUM(NSUInteger, UHArrowLabelDirection) {
    UHArrowLabelDirectionTop,
    UHArrowLabelDirectionBottom
};

@interface UHArrowLabel : UILabel

@property (nonatomic, assign) CGFloat textDistanceToBorder; // default is 10
@property (nonatomic, assign) CGFloat cornerRadius; // default is 5
@property (nonatomic, assign) CGFloat arrowHeight; // default is 10
@property (nonatomic, assign) CGFloat arrowWidth; // default is 20
@property (nonatomic, assign) CGFloat arrowJoinCornerRadius; // default is 3
@property (nonatomic, assign) CGFloat arrowMarginLeft; // default is center
@property (nonatomic, assign) UHArrowLabelDirection direction;

- (void) showAddedToView:(UIView *)view;

@end
