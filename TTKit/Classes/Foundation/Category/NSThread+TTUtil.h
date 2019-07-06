//
//  NSThread+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/29.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSThread (TTUtil)

/**
 在当前线程异步执行block
 */
- (void)tt_asycn:(dispatch_block_t)block completion:(dispatch_block_t)completion;

/**
 在当前线程同步执行block，注意死锁问题
 */
- (void)tt_sycn:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
