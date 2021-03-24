//
//  TTViewController+EntryPolicy.m
//  TTRabbit
//
//  Created by Rabbit on 2021/3/23.
//

#import "TTViewController+EntryPolicy.h"
#import <objc/runtime.h>

@implementation TTViewControllerEntryPolicy

- (void)tryWithCompletion:(TTEntryPolicyCompletion)completion {
    !completion ?: completion(YES);
}

@end

@implementation TTViewController (EntryPolicy)

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    TTViewController *ttViewController;
    if ([viewControllerToPresent isKindOfClass:[TTViewController class]]) {
        ttViewController = (TTViewController *)viewControllerToPresent;
    } else if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)viewControllerToPresent;
        if (navi.viewControllers.count && [navi.topViewController isKindOfClass:[TTViewController class]]) {
            ttViewController = (TTViewController *)navi.topViewController;
        }
    }
    if (!ttViewController.entryPolicies.count) {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
        return;
    }
    [ttViewController tryPoliciesWithCompletion:^(BOOL isDenied) {
        if (!isDenied) {
            [super presentViewController:viewControllerToPresent animated:flag completion:completion];
        }
    }];
}

- (void)tryPoliciesWithCompletion:(TTEntryPolicyCompletion)completion {
    if (!self.entryPolicies.count) {
        !completion ?: completion(NO);
        return;
    }
    NSMutableArray *policies = self.entryPolicies.mutableCopy;
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
            self.entryPolicies = nil;
            !completion ?: completion(NO);
            return;
        }
        [weakSelf tryEntryPolicies:policies withCompletion:completion];
    }];
}

- (NSArray *)entryPolicies {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setEntryPolicies:(NSArray *)entryPolicies {
    objc_setAssociatedObject(self, @selector(entryPolicies), entryPolicies, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

