//
//  TTNavigationControllerChildProtocol.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/24.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTNavigationControllerChildProtocol <NSObject>

@optional
// fromVC实现专场动画
- (id<UIViewControllerAnimatedTransitioning>)animatedTransitionFromSelfWithOperation:(UINavigationControllerOperation)operation
                                                                                toVC:(UIViewController *)toVC;
// toVC实现专场动画
- (id<UIViewControllerAnimatedTransitioning>)animatedTransitionToSelfWithOperation:(UINavigationControllerOperation)operation
                                                                            fromVC:(UIViewController *)fromVC;

// 点击了系统的返回按钮，是否可以返回
- (BOOL)navigationControllerShouldPopViewController;

@end
