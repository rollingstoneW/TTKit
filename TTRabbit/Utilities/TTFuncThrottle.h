//
//  TTFuncThrottle.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/28.
//

#import <Foundation/Foundation.h>
@class TTFuncThrottle;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTFuncThrottleType) {
    TTFuncThrottleTypeDelayAndInvoke, // 延迟指定时间执行，如果在等待执行期间再次调用相同任务，则取消之前等待的任务，重新开始等待
    TTFuncThrottleTypeInvokeAndIgnore,// 先执行，并取消在指定时间内新的任务
};

typedef NS_ENUM(NSUInteger, TTFuncThrottleState) {
    TTFuncThrottleStateWaiting, // 等待执行
    TTFuncThrottleStateInvoking, // 执行中
    TTFuncThrottleStateFinished, // 执行完成
    TTFuncThrottleStateCancelled // 被取消
};

/**
 函数节流

 @param threshold 时间阈值
 @param type 节流模式
 @param key  取消相同key的任务
 @param queue 执行的队列，不指定则为主线程
 @param block 执行的任务
 @return 如果被取消也会返回实例，供外界手动触发
 */
TTFuncThrottle *tt_throttle(NSTimeInterval threshold,
                            TTFuncThrottleType type,
                            NSString * _Nullable key,
                            dispatch_queue_t _Nullable queue,
                            dispatch_block_t block);

/**
 延迟执行，在指定时间内只执行一次，以调用此函数的所在的方法为key

 @param threshold 时间阈值
 @param queue 执行的队列，不指定则为主线程
 @param block 执行的任务
 */
TTFuncThrottle *tt_throttle_delay(NSTimeInterval threshold, dispatch_queue_t _Nullable queue, dispatch_block_t block);

/**
 先执行，然在指定时间内再次调用都会被取消，以调用此函数的所在的方法为key

 @param threshold 时间阈值
 @param queue 执行的队列，不指定则为主线程
 @param block 执行的任务
 */
TTFuncThrottle *tt_throttle_ignore(NSTimeInterval threshold, dispatch_queue_t _Nullable queue, dispatch_block_t block);

/**
 函数节流
 */
@interface TTFuncThrottle : NSObject

@property (nonatomic, assign, readonly) TTFuncThrottleType type;
@property (nonatomic, assign, readonly) TTFuncThrottleState state;
@property (nonatomic, copy, nullable) NSString *tag;

+ (instancetype)throttleDelay:(NSTimeInterval)threshold queue:(dispatch_queue_t _Nullable)queue block:(dispatch_block_t)block;
+ (instancetype)throttleIgnore:(NSTimeInterval)threshold queue:(dispatch_queue_t _Nullable)queue block:(dispatch_block_t)block;

+ (instancetype)throttle:(NSTimeInterval)threshold
                    type:(TTFuncThrottleType)type
                     key:(NSString * _Nullable)key
                   queue:(dispatch_queue_t _Nullable)queue
                   block:(dispatch_block_t)block;


/**
 立即执行当前任务，只有state为TTFuncThrottleStateWaiting的才会触发

 @return 是否成功触发
 */
- (BOOL)invokeInstantly;

/**
 取消当前任务
 */
- (void)cancel;

/**
 把取消的任务重新加入等待，会取消之前的任务
 */
- (void)rescheduleIfNeeded;

@end

NS_ASSUME_NONNULL_END

