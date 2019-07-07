//
//  TTTabBarController.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTTabBarAnimationProtocol
- (void)showSelectAnimationAtIndex:(NSInteger)index withImages:(NSArray *)images duration:(NSTimeInterval)duration;
- (void)stopSelectAnimationAtIndex:(NSInteger)index;
@end

@interface TTTabBarController : UITabBarController

@property (nonatomic, strong) Class customTabBarClass; 

/**
 在此方法内设置子控制器
 */
- (void)loadChildViewControllers;

/**
 设置tabBar点击动画

 @param animatedImages 序列帧动画数组
 @param duration 动画时长
 */
- (void)setupTabBarItemsWithAnimatedImages:(NSArray<NSArray *> *)animatedImages duration:(NSTimeInterval)duration;

@end
