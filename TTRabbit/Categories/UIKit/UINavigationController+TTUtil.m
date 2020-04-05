//
//  UINavigationController+TTUtil.m
//  TTRabbit
//
//  Created by rollingstoneW on 2019/11/8.
//

#import "UINavigationController+TTUtil.h"

@implementation UINavigationController (TTUtil)

- (nullable NSArray<__kindof UIViewController *> *)tt_popToNeareastViewController:(Class)aClass animated:(BOOL)animated {
    if (!aClass) {
        return nil;
    }
    for (UIViewController *child in self.viewControllers.reverseObjectEnumerator) {
        if ([child isKindOfClass:aClass]) {
            return [self popToViewController:child animated:animated];
            break;
        }
    }
    return nil;
}

- (NSArray<UIViewController *> *)tt_popToNeareastViewController2:(NSString *)className animated:(BOOL)animated {
    return [self tt_popToNeareastViewController:NSClassFromString(className) animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)tt_popToNeareastViewControllerIn:(NSArray<Class> *)classes animated:(BOOL)animated {
    if (!classes.count) {
        return nil;
    }
    for (UIViewController *child in self.viewControllers.reverseObjectEnumerator) {
        if ([classes containsObject:child.class]) {
            return [self popToViewController:child animated:animated];
            break;
        }
    }
    return nil;
}

- (NSArray<UIViewController *> *)tt_popToNeareastViewControllerIn2:(NSArray<NSString *> *)classNames animated:(BOOL)animated {
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:classNames.count];
    [classNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class aClass = NSClassFromString(obj);
        if (aClass) {
            [classes addObject:aClass];
        }
    }];
    return [self tt_popToNeareastViewControllerIn:classes animated:animated];
}

- (NSArray<UIViewController *> *)tt_popViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated {
    NSInteger index = self.viewControllers.count - 1 - level;
    UIViewController *vc = self.viewControllers[MAX(index, 0)];
    return [self popToViewController:vc animated:animated];
}

@end
