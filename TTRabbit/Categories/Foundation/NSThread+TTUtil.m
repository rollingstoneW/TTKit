//
//  NSThread+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/29.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSThread+TTUtil.h"

@implementation NSThread (TTUtil)

- (void)tt_asycn:(dispatch_block_t)block completion:(dispatch_block_t)completion {
    if (!block) { return; }
    NSDictionary *params;
    if (completion) {
        params = @{@"b" : block, @"c" : completion};
    } else {
        params = @{@"b" : block};
    }
    [self performSelector:@selector(tt_excuteBlockThenCompletionWithParams:) onThread:self withObject:params waitUntilDone:NO];
}

- (void)tt_sycn:(dispatch_block_t)block {
    if ([self isEqual:[NSThread currentThread]]) {
        NSAssert(NO, @"不要在同一个线程里同步执行代码，会造成死锁！！！");
        return;
    }
    if (!block) { return; }
    [self performSelector:@selector(tt_excuteBlockThenCompletionWithParams:) onThread:self withObject:@{@"b":block} waitUntilDone:YES];
}

- (void)tt_excuteBlockThenCompletionWithParams:(NSDictionary *)params {
    dispatch_block_t block = params[@"b"];
    block();
    dispatch_block_t completion = params[@"c"];
    !completion ?: completion();
}

@end
