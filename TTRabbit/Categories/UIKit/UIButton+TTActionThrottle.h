//
//  UIButton+TTActionThrottle.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/27.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSTimeInterval const TTButtonActionThrottleUsePreferThreshold;

/**
 指定时间内只响应一次点击事件
 */
@interface UIButton (TTActionThrottle)

@property (nonatomic, assign, class) NSTimeInterval tt_prefersThreshold; // 默认为0，不设置点击阈值

@property (nonatomic, assign) NSTimeInterval tt_threshold; // 默认为 TTButtonActionThrottleUsePreferThreshold，使用tt_prefersThreshold

@end

NS_ASSUME_NONNULL_END
