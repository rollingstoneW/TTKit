//
//  TTSemaphoreLock.h
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 基于信号量的锁，性能优越
 */
@interface TTSemaphoreLock : NSObject

/**
 通过最大并发数初始化锁

 @param count 最大并发数，需要>0
 */
- (instancetype)initWithMaxConcurrentCount:(NSUInteger)count;

/**
 上锁
 */
- (void)lock;

/**
 上锁，并设置超时时间
 */
- (void)lockWithTimeout:(NSUInteger)timeout;

/**
 解锁
 */
- (void)unlock;

/**
 在锁中执行任务
 */
- (void)lockExecution:(dispatch_block_t)execution;

/**
 在锁中执行任务，并设置超时时间
 */
- (void)lockWithTimeout:(NSUInteger)timeout execution:(dispatch_block_t)execution;

@end

NS_ASSUME_NONNULL_END
