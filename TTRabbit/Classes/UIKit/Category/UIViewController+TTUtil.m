//
//  UIViewController+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/20.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIViewController+TTUtil.h"
#import "UIView+TTToast.h"
#import "UIView+TTTips.h"
#import "TTMacros.h"
#import "TTUIKitFactory.h"

@implementation UIViewController (TTUtil)

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    self.navigationItem.titleView = [UILabel labelWithAttributedText:attributedTitle];
}

- (NSAttributedString *)attributedTitle {
    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        return ((UILabel *)self.navigationItem.titleView).attributedText;
    }
    return nil;
}

+ (UIViewController *)currentViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}

+ (UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController* svc = (UISplitViewController*)vc;
        if (svc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nvc = (UINavigationController*)vc;
        if (nvc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:nvc.topViewController];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tvc = (UITabBarController*)vc;
        if (tvc.viewControllers.count > 0) {
            return [UIViewController findBestViewController:tvc.selectedViewController];
        } else {
            return vc;
        }
    } else {
        return vc;
    }
}

- (void)goback {
    if (self.navigationController.viewControllers.count > 1 && self == self.navigationController.topViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)gobackToRoot {
    UINavigationController *rootNavi = [self rootNavigationViewController];
    if (rootNavi.presentedViewController) {
        [rootNavi dismissViewControllerAnimated:NO completion:nil];
    }
    [rootNavi popToRootViewControllerAnimated:YES];
}

- (BOOL)isMovingToViewHierarchy {
    return self.movingToParentViewController || self.beingPresented;
}

- (BOOL)isMovingFromViewHierarchy {
    return self.movingFromParentViewController || self.beingDismissed || self.navigationController.beingDismissed;
}

- (void)addSwipeDownGestureToDismiss {
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goback)];
    gesture.direction = UISwipeGestureRecognizerDirectionDown;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
}

- (void)disablesScrollViewScrollWhileSwipeBack:(UIScrollView *)scrollView {
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    //当是侧滑手势的时候设置scrollview需要此手势失效才生效即可
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [scrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
        }
    }
}

- (void)disablesScrollViewAutoAdjustContentInset:(UIScrollView *)scrollView {
    if (iOS11Later) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UINavigationController *)rootNavigationViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)window.rootViewController;
    } else if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectVc = [((UITabBarController *)window.rootViewController)selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)selectVc;
        }
    }
    return nil;
}

- (void)addLeftBarItemWithTitle:(NSString *)title image:(UIImage *)image selector:(SEL)selecor {
    if ((!title.length && !image) || ![self respondsToSelector:selecor]) { return; }

    UIBarButtonItem *item;
    if (title.length) {
        item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:selecor];
    } else {
        item = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                style:UIBarButtonItemStyleDone
                                               target:self
                                               action:selecor];
    }
    NSMutableArray *items = self.navigationItem.leftBarButtonItems ? [self.navigationItem.leftBarButtonItems mutableCopy] : [NSMutableArray array];
    [items addObject:item];
    self.navigationItem.leftBarButtonItems = items;
}

- (void)addRightBarItemWithTitle:(NSString *)title image:(UIImage *)image selector:(SEL)selecor {
    if ((!title.length && !image) || ![self respondsToSelector:selecor]) { return; }

    UIBarButtonItem *item;
    if (title.length) {
        item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:selecor];
    } else {
        item = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                style:UIBarButtonItemStyleDone
                                               target:self
                                               action:selecor];
    }
    NSMutableArray *items = self.navigationItem.rightBarButtonItems ? [self.navigationItem.rightBarButtonItems mutableCopy] : [NSMutableArray array];
    [items addObject:item];
    self.navigationItem.rightBarButtonItems = items;
}

- (UIAlertController *)showOKAlertWithTitle:(NSString *)title message:(NSString *)message handler:(dispatch_block_t)handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        kSafeBlock(handler);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

- (UIAlertController *)showCancelableAlertWithTitle:(NSString *)title message:(NSString *)message handler:(TTAlertHandler)handler {
    return [self showCancelableAlertWithTitle:title message:message cancelTitle:@"取消" OKTitle:@"确定" handler:handler];
}

- (UIAlertController *)showCancelableAlertWithTitle:(NSString *)title
                                                      message:(NSString *)message
                                                  cancelTitle:(NSString *)cancel
                                                      OKTitle:(NSString *)OKTitle
                                                      handler:(TTAlertHandler)handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        kSafeBlock(handler, 0);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:OKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        kSafeBlock(handler, 1);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

- (UIAlertController *)showActionSheetWithTitle:(NSString *)title
                                        message:(NSString *)message
                                        actions:(NSArray *)actions
                                        handler:(TTAlertHandler)handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < actions.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:actions[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            kSafeBlock(handler, i);
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        kSafeBlock(handler, -1);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

- (__kindof UIView *)showLoadingToast:(NSString *)toast {
    return [self.view showLoadingToast:toast];
}
- (__kindof UIView *)showLoadingToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view showLoadingToast:toast hideAfterDelay:delay];
}
- (void)hideToasts {
    [self.view hideToasts];
}

- (__kindof UIView *)showErrorToast:(NSString *)toast {
    return [self.view showErrorToast:toast];
}
- (__kindof UIView *)showErrorToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view showErrorToast:toast hideAfterDelay:delay];
}
- (__kindof UIView *)showSuccessToast:(NSString *)toast {
    return [self.view showSuccessToast:toast];
}
- (__kindof UIView *)showSuccessToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view showSuccessToast:toast hideAfterDelay:delay];
}
- (__kindof UIView *)showWarningToast:(NSString *)toast {
    return [self.view showWarningToast:toast];
}
- (__kindof UIView *)showWarningToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view showWarningToast:toast hideAfterDelay:delay];
}
- (__kindof UIView *)showTextToast:(NSString *)toast {
    return [self.view showTextToast:toast];
}
- (__kindof UIView *)showTextToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view showTextToast:toast hideAfterDelay:delay];
}

- (__kindof UIView *)tt_showEmptyTipViewWithTapedBlock:(dispatch_block_t)block {
    return [self.view tt_showEmptyTipViewWithTapedBlock:block];
}
- (__kindof UIView *)tt_showNetErrorTipViewWithTapedBlock:(dispatch_block_t)block {
    return [self.view tt_showNetErrorTipViewWithTapedBlock:block];
}
- (__kindof UIView *)tt_showTipViewWithTitle:(id)title image:(UIImage *)image tapedBlock:(dispatch_block_t)block {
    return [self.view tt_showTipViewWithTitle:title image:image tapedBlock:block];
}

- (UIView *)tt_showTipViewWithCustomView:(UIView *)customView tapedBlock:(dispatch_block_t)block {
    return [self.view tt_showTipViewWithCustomView:customView tapedBlock:block];
}

@end
