//
//  TTViewControllerEntryPolicy.m
//  TTRabbit
//
//  Created by ZYB on 2020/2/29.
//

#import "TTViewControllerEntryPolicy.h"
#import <objc/runtime.h>
#import "NSObject+YYAdd.h"

@implementation UINavigationController (TTEntryPolicy)

- (void)tt_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.viewControllers.count) {
        [self tt_pushViewController:viewController animated:animated];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(viewController) weakVC = viewController;
    [viewController tt_tryPoliciesWithCompletion:^(BOOL isDenied) {
        if (!isDenied && weakSelf && weakVC) {
            [weakSelf tt_pushViewController:weakVC animated:animated];
        }
    }];
}

@end

@implementation UIViewController (TTEntryPolicy)

- (void)tt_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(viewControllerToPresent) weakVC = viewControllerToPresent;
    [viewControllerToPresent tt_tryPoliciesWithCompletion:^(BOOL isDenied) {
        if (!isDenied && weakSelf && weakVC) {
            [weakSelf tt_presentViewController:weakVC animated:flag completion:completion];
        }
    }];
}

- (void)tt_tryPoliciesWithCompletion:(TTEntryPolicyCompletion)completion {
    if (!self.tt_entryPolicies.count) {
        !completion ?: completion(NO);
        return;
    }
    NSMutableArray *policies = self.tt_entryPolicies.mutableCopy;
    [self tryEntryPolicies:policies withCompletion:completion];
}

- (void)tryEntryPolicies:(NSMutableArray *)policies withCompletion:(TTEntryPolicyCompletion)completion {
    __weak __typeof(self) weakSelf = self;
    [policies.firstObject tryWithCompletion:^(BOOL isDenied) {
        if (isDenied) {
            !completion ?: completion(isDenied);
            return;
        }
        if (policies.count) {
            [policies removeObjectAtIndex:0];
        }
        if (!policies.count) {
            !completion ?: completion(NO);
            return;
        }
        [weakSelf tryEntryPolicies:policies withCompletion:completion];
    }];
}

- (NSArray *)tt_entryPolicies {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTt_entryPolicies:(NSArray *)entryPolicies {
    objc_setAssociatedObject(self, @selector(tt_entryPolicies), entryPolicies, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation TTViewControllerEntryPolicy

+ (void)load {
    [UINavigationController swizzleInstanceMethod:@selector(pushViewController:animated:) with:@selector(tt_pushViewController:animated:)];
    [UIViewController swizzleInstanceMethod:@selector(presentViewController:animated:completion:) with:@selector(tt_presentViewController:animated:completion:)];
}

- (void)tryWithCompletion:(TTEntryPolicyCompletion)completion {
    !completion ?: completion(YES);
}

@end
