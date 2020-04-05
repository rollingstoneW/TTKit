//
//  TTAlphaNavigationBar.h
//  TTKit
//
//  Created by rollingstoneW on 2018/9/18.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTNavigationBar.h"

FOUNDATION_EXTERN const UIControlState TTNavigationBarClearState;

@interface TTAlphaNavigationBar : TTNavigationBar

@property (nonatomic, assign) CGFloat offsetYToChangeAlpha;

@property (nonatomic, assign) BOOL isBackgroundClear;
@property (nonatomic, assign) BOOL showTitleWhenBackgroundClear;
@property (nonatomic, assign) BOOL autoAdjustStatusBarStyle;

- (void)setIsBackgroundClear:(BOOL)isBackgroundClear animated:(BOOL)animated;

- (void)handleScrollViewDidScroll:(UIScrollView *)scrollView;

@end
