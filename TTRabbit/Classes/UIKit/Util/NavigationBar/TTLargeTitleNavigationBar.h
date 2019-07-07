//
//  TTLargeTitleNavigationBar.h
//  TTKit
//
//  Created by rollingstoneW on 2018/6/22.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTNavigationBar.h"

@interface UIButton (TTNavigationBarHiddenControl)
@property (nonatomic, assign) BOOL hiddenWhenTitleHidden; // default YES
@end

@interface TTLargeTitleNavigationBar : TTNavigationBar

@property (nonatomic, strong, readonly) UIView *supplementView;
@property (nonatomic, strong) UIView *supplementRightView;
@property (nonatomic, assign) UIEdgeInsets supplementInsets UI_APPEARANCE_SELECTOR; // left、right、bottom, default is {0, 16, 16, 16}

@property (nonatomic, copy)   NSDictionary *largeTitleAttributes UI_APPEARANCE_SELECTOR; // default is font:28-bold, color:0x333333

@property (nonatomic, assign) CGFloat supplementHeight UI_APPEARANCE_SELECTOR; // default is 48
@property (nonatomic, assign) BOOL largeTitleHidden;
- (void)setLargeTitleHidden:(BOOL)hidden animated:(BOOL)animated layoutSuperview:(BOOL)layoutSuperview;

// dependent scrollView
@property (nonatomic, assign) CGFloat toStartShowContentOffsetY; // 开始显示大标题的contentOffsetY
- (void)handleScrollViewContentOffsetY:(CGFloat)contentOffsetY; // 根据scrollView的偏移量设置大标题展示的比例(showingPercent)
@property (nonatomic, assign) CGFloat showingPercent; // 大标题展示的比例

@end
