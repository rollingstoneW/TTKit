//
//  TTAbstractPopupView.h
//  TTKit
//
//  Created by rollingstoneW on 2018/8/10.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPopupViewManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSInteger TTPopupShowingPriority;

UIKIT_EXTERN const TTPopupShowingPriority TTPopupShowingPriorityHigh;
UIKIT_EXTERN const TTPopupShowingPriority TTPopupShowingPriorityMedium;
UIKIT_EXTERN const TTPopupShowingPriority TTPopupShowingPriorityDefaultLow;


typedef NS_ENUM(NSUInteger, TTPopupShowingPolicy) {
    TTPopupShowingForSure = 0, // 一定会展示
    TTPopupShowingOnlyNoneExists, // 只有展示的popupView.showingPriority全部<self.showingPriority时才会展示
    TTPopupShowingAfterOthersDismiss // 等到在展示的popupView.showingPriority全部<self.showingPriority才会展示
};

typedef NS_ENUM(NSUInteger, TTPopupDismissOthersPolicy) {
    TTPopupDismissOthersPolicyNone = 0,
    TTPopupDismissOthersPriorityLower, // 展示的时候，会关闭比自己优先级低的popupView
    TTPopupDismissOthersPriorityLowerOrEqual, // 展示的时候，会关闭不大于自己优先级的popupView
};

@interface TTAbstractPopupView : UIView

@property (nonatomic, strong, readonly) UIView *containerView;

@property (nonatomic, assign) TTPopupShowingPolicy showingPolicy;
@property (nonatomic, assign) TTPopupDismissOthersPolicy dismissPolicy;
@property (nonatomic, assign) TTPopupShowingPriority showingPriority;

@property (nonatomic, strong, nullable) __kindof TTPopupViewManager *popupMangager; // 默认是globlePopupManager

@property (nonatomic, assign) CGRect containerFrame;

@property (nonatomic, assign) BOOL dimBackground; // 显示黑色蒙层 YES
@property (nonatomic, assign) BOOL tapDimToDismiss; // 点击蒙层是否消失 NO

@property (nonatomic, assign) BOOL dismissWhenConfirm; // 点击确定后是否消失，子类使用 YES

@property (nonatomic, copy, nullable) dispatch_block_t confirmedBlock; // 确定的回调，子类使用
@property (nonatomic, copy, nullable) dispatch_block_t cancelledBlock; // 取消的回调，子类使用
@property (nonatomic, copy, nullable) dispatch_block_t dismissedBlock; // 消失的回调

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)showInMainWindow;
- (void)showInKeyWindow;
- (void)dismissWithCompletion:(nullable dispatch_block_t)completion animated:(BOOL)animated; // 消失
- (void)dismiss; // 消失

- (void)willShow:(BOOL)animated;
- (void)didShow:(BOOL)animated;
- (void)willDismiss:(BOOL)animated;
- (void)didDismiss:(BOOL)animated;

// 子类可重写来自定义动画
- (void)presentShowingAnimationWithCompletion:(dispatch_block_t)completion;
- (void)presentDismissingAnimationWithCompletion:(dispatch_block_t)completion;
// 统一初始化方法
- (void)setup NS_REQUIRES_SUPER;

// 是否可以被popupView(popupView.showingPriority>=self.showingPriority)自动取消, YES
- (BOOL)shouldBeDismissedByPopupView:(__kindof TTAbstractPopupView *)popupView;

@end

NS_ASSUME_NONNULL_END
