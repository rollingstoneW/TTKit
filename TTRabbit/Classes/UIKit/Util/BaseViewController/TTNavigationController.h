//
//  TTNavigationController.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id<UIViewControllerAnimatedTransitioning>(^NavAnimatedTransitionBlock)(UINavigationControllerOperation operation, UIViewController *fromVC, UIViewController *toVC);

@interface TTNavigationController : UINavigationController <UINavigationControllerDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) UIImage *backIndicatorImage; // 导航栏返回按钮图片
@property (nonatomic, copy) NavAnimatedTransitionBlock animatedTransitionBlock;

@end
