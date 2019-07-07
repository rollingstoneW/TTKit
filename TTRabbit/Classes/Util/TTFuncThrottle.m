//
//  TTFuncThrottle.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/28.
//

#import "TTFuncThrottle.h"

TTFuncThrottle *tt_throttle_delay(NSTimeInterval threshold, dispatch_queue_t _Nullable queue, dispatch_block_t block) {
    return [TTFuncThrottle throttleDelay:threshold queue:queue block:block];
}

TTFuncThrottle *tt_throttle_ignore(NSTimeInterval threshold, dispatch_queue_t _Nullable queue, dispatch_block_t block) {
    return [TTFuncThrottle throttleIgnore:threshold queue:queue block:block];
}

TTFuncThrottle *tt_throttle(NSTimeInterval threshold,
                                TTFuncThrottleType type,
                                NSString * _Nullable key,
                                dispatch_queue_t _Nullable queue,
                                dispatch_block_t block) {
    return [TTFuncThrottle throttle:threshold type:type key:key queue:queue block:block];
}

@interface TTFuncThrottle ()

@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, strong) dispatch_block_t block;
@property (nonatomic, assign) dispatch_source_t source;
@property (nonatomic, assign) dispatch_queue_t queue;
@property (nonatomic,   copy) NSString *key;
@property (nonatomic, assign) TTFuncThrottleType type;
@property (nonatomic, assign) TTFuncThrottleState state;

@property (nonatomic, strong, readonly, class) NSMutableDictionary *globalThrottles;

@end

@implementation TTFuncThrottle

+ (instancetype)throttleDelay:(NSTimeInterval)threshold queue:(dispatch_queue_t _Nullable)queue block:(dispatch_block_t)block {
    return [self throttle:threshold type:TTFuncThrottleTypeDelayAndInvoke key:nil queue:queue block:block];
}

+ (instancetype)throttleIgnore:(NSTimeInterval)threshold queue:(dispatch_queue_t _Nullable)queue block:(dispatch_block_t)block {
    return [self throttle:threshold type:TTFuncThrottleTypeInvokeAndIgnore key:nil queue:queue block:block];
}

+ (instancetype)throttle:(NSTimeInterval)threshold
                    type:(TTFuncThrottleType)type
                     key:(NSString *_Nullable)key
                   queue:(dispatch_queue_t _Nullable)queue
                   block:(dispatch_block_t)block {
    key = key ?: [NSThread callStackSymbols][1];
    queue = queue ?: dispatch_get_main_queue();

    TTFuncThrottle *throttle = self.globalThrottles[key];
    if (type == TTFuncThrottleTypeDelayAndInvoke) {
        [throttle cancel];

        throttle = [[TTFuncThrottle alloc] init];
        throttle.type = type;
        [throttle scheduleWithThreshold:threshold key:key block:block queue:queue withHandler:^{
            [throttle invoke];
            [self.globalThrottles removeObjectForKey:key];
        }];
        self.globalThrottles[key] = throttle;
    } else if (type == TTFuncThrottleTypeInvokeAndIgnore) {
        TTFuncThrottle *newThrottle = [[TTFuncThrottle alloc] init];
        throttle.type = type;
        if (throttle) {
            newThrottle.queue = queue;
            newThrottle.block = block;
            newThrottle.key = key;
            newThrottle.delay = threshold;
            newThrottle.state = TTFuncThrottleStateCancelled;
            // 取消实例并返回，供外界手动触发
            return newThrottle;
        }
        throttle = newThrottle;
        [throttle scheduleWithThreshold:threshold key:key block:block queue:queue withHandler:^{
            [self.globalThrottles removeObjectForKey:key];
        }];
        dispatch_async(queue, ^{
            [throttle invoke];
        });
        self.globalThrottles[key] = throttle;
    }
    return throttle;
}



- (void)scheduleWithThreshold:(NSTimeInterval)threshold key:(NSString *)key block:(dispatch_block_t)block queue:(dispatch_queue_t)queue withHandler:(dispatch_block_t)handler {
    dispatch_queue_set_specific(queue, (__bridge void *)self, (__bridge void *)self, NULL);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(source, dispatch_time(DISPATCH_TIME_NOW, threshold * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(source, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        dispatch_source_cancel(source);
        strongSelf.source = NULL;
        !handler ?: handler();
    });
    self.queue = queue;
    self.source = source;
    self.block = block;
    self.key = key;
    self.delay = threshold;
    dispatch_resume(source);
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        NSLog(@"注册了%@", self.tag);
    //    });
}

- (void)cancel {
    if (self.state == TTFuncThrottleStateCancelled) {
        return;
    }
    if (self.type == TTFuncThrottleTypeDelayAndInvoke && self.state != TTFuncThrottleStateWaiting) {
        return;
    }
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = NULL;
    }
    [[self class].globalThrottles removeObjectForKey:self.key];
    self.state = TTFuncThrottleStateCancelled;
    //    NSLog(@"取消了%@", self.tag);
}

- (void)invoke {
    if (self.state != TTFuncThrottleStateWaiting) {
        return;
    }
    self.state = TTFuncThrottleStateInvoking;
    //    NSLog(@"开始执行%@", self.tag);
    !self.block ?: self.block();
    self.state = TTFuncThrottleStateFinished;
    //    NSLog(@"执行了%@", self.tag);
}

- (BOOL)invokeInstantly {
    if (self.state != TTFuncThrottleStateWaiting) {
        return NO;
    }
    [self invoke];
    return YES;
}

- (void)rescheduleIfNeeded {
    if (self.state != TTFuncThrottleStateCancelled) {
        return;
    }
    TTFuncThrottle *throttle = [self class].globalThrottles[self.key];
    [throttle cancel];
    if (self.type == TTFuncThrottleTypeDelayAndInvoke) {
        [self scheduleWithThreshold:self.delay key:self.key block:self.block queue:self.queue withHandler:^{
            [self invoke];
            [[self class].globalThrottles removeObjectForKey:self.key];
        }];
        [self class].globalThrottles[self.key] = self;
    } else if (self.type == TTFuncThrottleTypeInvokeAndIgnore) {
        [self scheduleWithThreshold:self.delay key:self.key block:self.block queue:self.queue withHandler:^{
            [[self class].globalThrottles removeObjectForKey:self.key];
        }];
        [self class].globalThrottles[self.key] = self;
        dispatch_async(self.queue, ^{
            [throttle invoke];
        });
    }
    self.state = TTFuncThrottleStateWaiting;
}

- (void)dealloc {
    [self cancel];
    self.source = NULL;
    self.queue = NULL;
    self.block = nil;
    //    NSLog(@"释放了%@", self.tag);
}

+ (NSMutableDictionary *)globalThrottles {
    static NSMutableDictionary *_globalThrottles;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _globalThrottles = [NSMutableDictionary dictionary];
    });
    return _globalThrottles;
}

@end
