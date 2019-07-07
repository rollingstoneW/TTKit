//
//  TTPopupViewManager.h
//  TTKit
//
//  Created by rollingstoneW on 2018/9/3.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+TTSingleton.h"

@class TTAbstractPopupView;

NS_ASSUME_NONNULL_BEGIN

@interface TTPopupViewManager : NSObject <TTSingleton>

@property (nonatomic, strong) NSMutableArray<__kindof TTAbstractPopupView *>* showingPopupViews;
@property (nonatomic, strong) NSMutableArray<__kindof TTAbstractPopupView *>* toShowingPopupViews;

- (void)showPopupView:(TTAbstractPopupView *)popupView inView:(UIView *)superview animated:(BOOL)animated;
- (void)dismissedPopupView:(TTAbstractPopupView *)popupView;

- (nullable NSArray<__kindof TTAbstractPopupView *> *)popupViewsInView:(UIView *)view containToShow:(BOOL)containToShow;

+ (instancetype)lazilyGlobleManager;

@end

NS_ASSUME_NONNULL_END
