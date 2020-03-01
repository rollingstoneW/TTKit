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

- (void)setTt_attributedTitle:(NSAttributedString *)tt_attributedTitle {
    self.navigationItem.titleView = [UILabel labelWithAttributedText:tt_attributedTitle];
}

- (NSAttributedString *)tt_attributedTitle {
    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        return ((UILabel *)self.navigationItem.titleView).attributedText;
    }
    return nil;
}

+ (UIViewController *)tt_currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController tt_findBestViewController:viewController];
}

+ (UIViewController *)tt_findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        return [self tt_findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController* svc = (UISplitViewController*)vc;
        if (svc.viewControllers.count > 0) {
            return [self tt_findBestViewController:svc.viewControllers.lastObject];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nvc = (UINavigationController*)vc;
        if (nvc.viewControllers.count > 0) {
            return [self tt_findBestViewController:nvc.topViewController];
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tvc = (UITabBarController*)vc;
        if (tvc.viewControllers.count > 0) {
            return [self tt_findBestViewController:tvc.selectedViewController];
        } else {
            return vc;
        }
    } else {
        return vc;
    }
}

- (UIViewController *)tt_belowViewController {
    if (self.navigationController && self.navigationController.viewControllers.firstObject != self) {
        NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
        if (self.navigationController.viewControllers.count > currentIndex - 1) {
            return self.navigationController.viewControllers[currentIndex - 1];
        }
    }
    return self.presentingViewController;
}

- (void)tt_goback {
    if (self.navigationController.viewControllers.count > 1 && self == self.navigationController.topViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)tt_gobackToRoot {
    UINavigationController *rootNavi = [self tt_rootNavigationViewController];
    if (rootNavi.presentedViewController) {
        [rootNavi dismissViewControllerAnimated:NO completion:nil];
    }
    [rootNavi popToRootViewControllerAnimated:YES];
}

- (BOOL)tt_isMovingToViewHierarchy {
    return self.movingToParentViewController || self.beingPresented;
}

- (BOOL)tt_isMovingFromViewHierarchy {
    return self.movingFromParentViewController || self.beingDismissed || self.navigationController.beingDismissed;
}

- (void)tt_addSwipeDownGestureToDismiss {
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tt_goback)];
    gesture.direction = UISwipeGestureRecognizerDirectionDown;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gesture];
}

- (void)tt_disablesScrollViewScrollWhileSwipeBack:(UIScrollView *)scrollView {
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    //当是侧滑手势的时候设置scrollview需要此手势失效才生效即可
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [scrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
        }
    }
}

- (void)tt_disablesScrollViewAutoAdjustContentInset:(UIScrollView *)scrollView {
    if (kiOS11Later) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UINavigationController *)tt_rootNavigationViewController {
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

- (void)tt_addLeftBarItemWithTitle:(NSString *)title image:(UIImage *)image selector:(SEL)selecor {
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

- (void)tt_addRightBarItemWithTitle:(NSString *)title image:(UIImage *)image selector:(SEL)selecor {
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

- (void)tt_addRightBarItemWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color selector:(SEL)selecor {
    UIButton *button = [UIButton buttonWithTitle:title font:font titleColor:color];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [button sizeToFit];
    [button addTarget:self action:selecor forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSMutableArray *items = self.navigationItem.rightBarButtonItems ? [self.navigationItem.rightBarButtonItems mutableCopy] : [NSMutableArray array];
    [items addObject:item];
    self.navigationItem.rightBarButtonItems = items;
}

- (id)tt_postMessageToBelow:(NSString *)message object:(id)object userInfo:(NSDictionary *)userInfo {
    return [self.tt_belowViewController tt_postMessageToBelow:message object:object userInfo:userInfo];
}

- (UIAlertController *)tt_showOKAlertWithTitle:(NSString *)title message:(NSString *)message handler:(dispatch_block_t _Nullable)handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TTSafeBlock(handler);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

- (UIAlertController *)tt_showCancelableAlertWithTitle:(NSString *)title message:(NSString *)message handler:(TTAlertHandler)handler {
    return [self tt_showCancelableAlertWithTitle:title message:message cancelTitle:@"取消" OKTitle:@"确定" handler:handler];
}

- (UIAlertController *)tt_showCancelableAlertWithTitle:(NSString *)title
                                               message:(NSString *)message
                                           cancelTitle:(NSString *)cancel
                                               OKTitle:(NSString *)OKTitle
                                               handler:(TTAlertHandler)handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TTSafeBlock(handler, 0);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:OKTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TTSafeBlock(handler, 1);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

- (UIAlertController *)tt_showActionSheetWithTitle:(NSString *)title
                                           message:(NSString *)message
                                           actions:(NSArray *)actions
                                           handler:(TTAlertHandler)handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < actions.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:actions[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TTSafeBlock(handler, i);
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        TTSafeBlock(handler, -1);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return alert;
}

- (__kindof UIView *)tt_showLoadingToast:(NSString *)toast {
    return [self.view tt_showLoadingToast:toast];
}
- (__kindof UIView *)tt_showLoadingToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view tt_showLoadingToast:toast hideAfterDelay:delay];
}
- (void)tt_hideToasts {
    [self.view tt_hideToasts];
}

- (__kindof UIView *)tt_showErrorToast:(NSString *)toast {
    return [self.view tt_showErrorToast:toast];
}
- (__kindof UIView *)tt_showErrorToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view tt_showErrorToast:toast hideAfterDelay:delay];
}
- (__kindof UIView *)tt_showSuccessToast:(NSString *)toast {
    return [self.view tt_showSuccessToast:toast];
}
- (__kindof UIView *)tt_showSuccessToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view tt_showSuccessToast:toast hideAfterDelay:delay];
}
- (__kindof UIView *)tt_showWarningToast:(NSString *)toast {
    return [self.view tt_showWarningToast:toast];
}
- (__kindof UIView *)tt_showWarningToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view tt_showWarningToast:toast hideAfterDelay:delay];
}
- (__kindof UIView *)tt_showTextToast:(NSString *)toast {
    return [self.view tt_showTextToast:toast];
}
- (__kindof UIView *)tt_showTextToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    return [self.view tt_showTextToast:toast hideAfterDelay:delay];
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
