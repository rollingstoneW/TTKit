//
//  NSObject+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTObserveChangedBlock)(id newData, id oldData, void * _Nullable context);

@interface NSObject (TTUtil)

/**
 关联弱引用对象

 @param object 需要被关联的对象
 @param key 常量地址
 */
- (void)tt_setAssociateWeakObject:(id _Nullable)object forKey:(const void *)key;

/**
 获取被关联的弱引用对象
 @param key 常量地址
 */
- (id _Nullable)tt_associateWeakObjectForKey:(const void *)key;

/**
 自己通过KVO观察对象。可以在多处观察同一个对象的同一个keyPath，对应的block都会回掉。自己销毁时会自动移除观察者

 @param object 被观察的对象
 @param keyPath 对象被观察的keyPath
 @param context 上下文
 @param changed 发生变化的回掉
 */
- (void)tt_observeObject:(id)object forKeyPath:(NSString *)keyPath context:(nullable void *)context changed:(TTObserveChangedBlock)changed;

/**
 自己停止观察对象

 @param object 被观察的对象
 @param keyPath 对象被观察的keyPath
 */
- (void)tt_stopObserveObject:(id)object forKeyPath:(NSString *)keyPath;


- (id)tt_performSelectorWithArgs:(SEL)sel, ...;

- (id)tt_performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;

- (id)tt_performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...;

- (id)tt_performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thr waitUntilDone:(BOOL)wait, ...;

- (void)tt_performSelectorWithArgsInBackground:(SEL)sel, ...;

- (void)tt_cancelPreviousPerformRequestWithObject:(id)object;

/**
 注册监听dealloc方法的block，对于同一个对象可以注册多个block
 */
- (void)tt_scheduleDeallocedBlock:(void(^)(id object))block;

/**
 内存地址
 */
- (NSString *)tt_debugAddress;

/**
 类的继承链
 */
- (NSString *)tt_classHierarchy;

@end

NS_ASSUME_NONNULL_END
