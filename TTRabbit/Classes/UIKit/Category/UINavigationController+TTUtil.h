//
//  UINavigationController+TTUtil.h
//  TTRabbit
//
//  Created by rollingstoneW on 2019/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (TTUtil)

/**
 pop到最近的一个aClass类型的控制器
*/
- (nullable NSArray<__kindof UIViewController *> *)tt_popToNeareastViewController:(Class)aClass animated:(BOOL)animated;
/**
 pop到最近的一个aClass类型的控制器
*/
- (nullable NSArray<__kindof UIViewController *> *)tt_popToNeareastViewController2:(NSString *)className animated:(BOOL)animated;

/**
 pop到classes类型中的最近的控制器
*/
- (nullable NSArray<__kindof UIViewController *> *)tt_popToNeareastViewControllerIn:(NSArray<Class> *)classes animated:(BOOL)animated;
/**
 pop到classes类型中的最近的控制器
*/
- (nullable NSArray<__kindof UIViewController *> *)tt_popToNeareastViewControllerIn2:(NSArray<NSString *> *)classNames animated:(BOOL)animated;

/**
 pop指定个数的页面
*/
- (nullable NSArray<__kindof UIViewController *> *)tt_popViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
