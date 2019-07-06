//
//  TTSemaphoreLock.m
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTSemaphoreLock.h"

@interface TTSemaphoreLock ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation TTSemaphoreLock

- (instancetype)initWithMaxConcurrentCount:(NSUInteger)count {
    if (!count) { return nil; }
    if (self = [super init]) {
        _semaphore = dispatch_semaphore_create(count);
    }
    return self;
}

- (void)lock {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

- (void)lockWithTimeout:(NSUInteger)timeout {
    dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, timeout));
}

- (void)unlock {
    dispatch_semaphore_signal(self.semaphore);
}

- (void)lockExecution:(dispatch_block_t)execution {
    if (!execution) { return; }
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    execution();
    dispatch_semaphore_signal(self.semaphore);
}

- (void)lockWithTimeout:(NSUInteger)timeout execution:(dispatch_block_t)execution {
    if (!execution) { return; }
    dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, timeout));
    execution();
    dispatch_semaphore_signal(self.semaphore);
}

@end
