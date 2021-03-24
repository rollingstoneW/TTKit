//
//  TTNavigationController.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef id<UIViewControllerAnimatedTransitioning>_Nullable(^NavAnimatedTransitionBlock)(UINavigationControllerOperation operation, UIViewController *fromVC, UIViewController *toVC);

@interface TTNavigationController : UINavigationController <UINavigationControllerDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) UIImage *backIndicatorImage; // 导航栏返回按钮图片
@property (class, nonatomic, strong) UIImage *defaultBackIndicatorImage; // 导航栏默认返回按钮图片
@property (nonatomic, copy) NavAnimatedTransitionBlock animatedTransitionBlock;

@end

NS_ASSUME_NONNULL_END
