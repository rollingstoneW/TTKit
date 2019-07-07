//
//  TTTransitionPresentContoller.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/24.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTTransitionPresentContoller.h"
#import "TTKit.h"
#import "UIView+YYAdd.h"

@implementation TTTransitionPresentContoller

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;

    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];

    BOOL fromHideNavBar = [fromVC isKindOfClass:[TTViewController class]] && ((TTViewController *)fromVC).tt_prefersStatusBarHidden;
    BOOL toHideNavBar = [toVC isKindOfClass:[TTViewController class]] && ((TTViewController *)toVC).tt_prefersStatusBarHidden;

    CGFloat fromNavHeight = fromHideNavBar ? 0 : kNavigationBarBottom;
    CGFloat toNavHeight = toHideNavBar ? 0 : kNavigationBarBottom;

    if (self.isReverse) {
        toView.frame = CGRectMake(0, toNavHeight, kScreenWidth, kScreenHeight - toNavHeight);
        [containerView sendSubviewToBack:toView];
    } else {
        toView.frame = CGRectMake(0, kScreenHeight - toNavHeight, kScreenWidth, kScreenHeight - toNavHeight);
    }

    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    UITabBar *tabBar;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        tabBar = [(UITabBarController *)rootVC tabBar];
    }

    tabBar.left = -kScreenWidth;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.isReverse) {
                             fromView.top = kScreenHeight - fromNavHeight;
                         } else {
                             toView.top = toNavHeight;
                         }
                     } completion:^(BOOL finished) {
                         [fromView removeFromSuperview];
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
