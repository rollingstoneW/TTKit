//
//  TTViewController+LifeCycle.h
//  TTRabbit
//
//  Created by Rabbit on 2021/3/23.
//

#import "TTViewController.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSNotificationName TTViewControllerViewDidLoadNotification;
FOUNDATION_EXTERN NSNotificationName TTViewControllerViewWillAppearNotification;
FOUNDATION_EXTERN NSNotificationName TTViewControllerViewDidAppearNotification;
FOUNDATION_EXTERN NSNotificationName TTViewControllerViewWillDisappearNotification;
FOUNDATION_EXTERN NSNotificationName TTViewControllerViewDidDisappearNotification;
FOUNDATION_EXTERN NSNotificationName TTViewControllerViewDeallocedNotification;

typedef NS_ENUM(NSUInteger, TTViewControllerLifeCycleState) {
    TTViewControllerLifeCycleStateUninited = 0,
    TTViewControllerLifeCycleStateInited,
    TTViewControllerLifeCycleStateBeforeDidLoad,
    TTViewControllerLifeCycleStateDidLoad,
    TTViewControllerLifeCycleStateBeforeWillAppear,
    TTViewControllerLifeCycleStateWillAppear,
    TTViewControllerLifeCycleStateBeforeDidAppear,
    TTViewControllerLifeCycleStateDidAppear,
    TTViewControllerLifeCycleStateBeforeWillDisappear,
    TTViewControllerLifeCycleStateWillDisappear,
    TTViewControllerLifeCycleStateBeforeDidDisappear,
    TTViewControllerLifeCycleStateDidDisappear,
    TTViewControllerLifeCycleStateDealloced,
};

@interface TTViewController ()

@property (nonatomic, assign, class) BOOL postLifeCycleNotifications; // 是否发送生命周期的通知，默认为NO
@property (nonatomic, assign) TTViewControllerLifeCycleState lifeCycleState; // 当前的生命周期状态

- (void)excuteWhenDidAppear:(dispatch_block_t)didAppear invokesAlways:(BOOL)invokesAlways;
- (void)excuteWhenWillAppear:(dispatch_block_t)willAppear invokesAlways:(BOOL)invokesAlways;
- (void)excuteWhenWillDisappear:(dispatch_block_t)willDisappear invokesAlways:(BOOL)invokesAlways;
- (void)excuteWhenDidDisappear:(dispatch_block_t)didDisappear invokesAlways:(BOOL)invokesAlways;

@end

NS_ASSUME_NONNULL_END
