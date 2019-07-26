//
//  TTTabBarController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTTabBarController.h"
#import "TTTabBarControllerChildProtocol.h"
#import "Masonry.h"
#import "TTMacros.h"

static NSTimeInterval DoubleTapMaxInterval = 0.25;

@interface TTTabBar : UITabBar <TTTabBarAnimationProtocol>
@property (nonatomic, strong) NSArray<UIImageView *>* tabBarButtonImageViews;
@end

@implementation TTTabBar

- (void)showSelectAnimationAtIndex:(NSInteger)index withImages:(NSArray *)images duration:(NSTimeInterval)duration {
    UIImageView *animatedImageView = [self tabBarButtonImageViewAtIndex:index];
    animatedImageView.animationImages = images;
    animatedImageView.animationDuration = duration;
    animatedImageView.animationRepeatCount = 1;
    [animatedImageView startAnimating];
}

- (void)stopSelectAnimationAtIndex:(NSInteger)index {
    UIImageView *animatedImageView = [self tabBarButtonImageViewAtIndex:index];
    [animatedImageView stopAnimating];
    animatedImageView.animationImages = nil;
}

- (void)setItems:(NSArray<UITabBarItem *> *)items animated:(BOOL)animated {
    [super setItems:items animated:animated];
    self.tabBarButtonImageViews = nil;
}

- (UIImageView *)tabBarButtonImageViewAtIndex:(NSInteger)index {
    if (!self.items.count || ![self.items.firstObject respondsToSelector:@selector(view)]) {
        return nil;
    }
    NSMutableArray *tabBarButtons = [[self.items valueForKeyPath:@"view"] mutableCopy];
    [tabBarButtons sortUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        return obj1.frame.origin.x > obj2.frame.origin.x;
    }];
    return [self imageViewInTabBarButton:tabBarButtons[index]];
}

- (UIImageView *)imageViewInTabBarButton:(UIView *)button {
    for (UIImageView *subview in button.subviews) {
        if ([subview isKindOfClass:[UIImageView class]] && [NSStringFromClass([subview class]) hasPrefix:@"UITabBar"]) {
            return subview;
        }
    }
    return nil;
}

@end

@interface TTTabBarController () <UITabBarControllerDelegate, UITabBarDelegate, CAAnimationDelegate>

@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic, strong) NSDate *lastSelectedDate;

@property (nonatomic, strong) NSArray *animatedImages;
@property (nonatomic, assign) NSTimeInterval animatedDuration;

@end

@implementation TTTabBarController

- (void)viewDidLoad {
    [self loadChildViewControllers];
    [super viewDidLoad];

    self.selectedIndex = 0;
    _customTabBarClass = [TTTabBar class];

    if (self.customTabBarClass) {
        [self setValue:[self.customTabBarClass new] forKey:@"tabBar"];
    }

    self.delegate = self;
}

- (void)loadChildViewControllers {}

- (void)setupTabBarItemsWithAnimatedImages:(NSArray<NSArray *> *)animatedImages duration:(NSTimeInterval)duration {
    if (animatedImages.count != self.viewControllers.count || ![animatedImages.firstObject isKindOfClass:[NSArray class]]) {
        NSLog(@"animatedImages 数据有误");
        return;
    }
    
    self.animatedImages = animatedImages;
    self.animatedDuration = duration;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    [self stopTabBarItemAnimationAtIndex:self.lastSelectedIndex];
    self.lastSelectedIndex = selectedIndex;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger selectedIndex = [self.viewControllers indexOfObject:viewController];
    [self showTabBarItemAnimationAtIndex:selectedIndex];

    if (selectedIndex == self.lastSelectedIndex) {
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.lastSelectedDate];
        if (time < DoubleTapMaxInterval) {
            [TTTabBarController cancelPreviousPerformRequestsWithTarget:self
                                                               selector:@selector(notifyViewControllerTabReselected:)
                                                                 object:viewController];
            [self notifyViewController:viewController action:@selector(tabDoubleTaped)];
        } else {
            [self performSelector:@selector(notifyViewControllerTabReselected:) withObject:viewController afterDelay:DoubleTapMaxInterval];
        }
    }
    self.lastSelectedIndex = selectedIndex;
    self.lastSelectedDate = [NSDate date];
}

- (void)showTabBarItemAnimationAtIndex:(NSInteger)index {
    if (!self.animatedImages.count || ![self.tabBar conformsToProtocol:@protocol(TTTabBarAnimationProtocol)]) { return; }
    id<TTTabBarAnimationProtocol> tabBar = (id<TTTabBarAnimationProtocol>)self.tabBar;
    [tabBar stopSelectAnimationAtIndex:self.lastSelectedIndex];
    [tabBar showSelectAnimationAtIndex:index withImages:self.animatedImages[index] duration:self.animatedDuration];
}

- (void)stopTabBarItemAnimationAtIndex:(NSInteger)index {
    if (!self.animatedImages.count || ![self.tabBar conformsToProtocol:@protocol(TTTabBarAnimationProtocol)]) { return; }
    id<TTTabBarAnimationProtocol> tabBar = (id<TTTabBarAnimationProtocol>)self.tabBar;
    [tabBar stopSelectAnimationAtIndex:index];
}

- (void)notifyViewControllerTabReselected:(UIViewController *)viewController {
    [self notifyViewController:viewController action:@selector(tabReSelected)];
}

- (void)notifyViewController:(UIViewController *)viewController action:(SEL)action {
    if ([viewController respondsToSelector:action]) {
        SuppressPerformSelectorLeakWarning([viewController performSelector:action];)
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *rootVC = [(UINavigationController *)viewController viewControllers].firstObject;
        if ([rootVC respondsToSelector:action]) {
            SuppressPerformSelectorLeakWarning([rootVC performSelector:action];)
        }
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    if (self.selectedViewController) {
//        return self.selectedViewController.preferredStatusBarStyle;
//    }
//    return UIStatusBarStyleDefault;
//}
//
//- (BOOL)prefersStatusBarHidden {
//    if (self.selectedViewController) {
//        return self.selectedViewController.prefersStatusBarHidden;
//    }
//    return NO;
//}
//
//- (BOOL)shouldAutorotate {
//    if (self.selectedViewController) {
//        return self.selectedViewController.shouldAutorotate;
//    }
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    if (self.selectedViewController) {
//        return self.selectedViewController.supportedInterfaceOrientations;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    if (self.selectedViewController) {
//        return self.selectedViewController.preferredInterfaceOrientationForPresentation;
//    }
//    return UIInterfaceOrientationPortrait;
//}

@end
