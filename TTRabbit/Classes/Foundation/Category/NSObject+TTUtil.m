//
//  NSObject+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSObject+TTUtil.h"
#import <objc/runtime.h>
#import "NSInvocation+TTUtil.h"

static const void * TTKVOObserverAssociationKey = &TTKVOObserverAssociationKey;
static const void * TTDeallocObserverAssociationKey = &TTDeallocObserverAssociationKey;

@interface _TTWeakReference : NSObject
@property (nonatomic, weak) id weakValue;
@end
@implementation _TTWeakReference
@end

@interface _TTDeallocObserver : NSObject
@property (nonatomic, assign) id object;
@property (nonatomic, strong) void(^block)(id);
@property (nonatomic, strong) NSMutableSet *blocks;
@end
@implementation _TTDeallocObserver
+ (void)observeDeallocOfObject:(id)object block:(void(^)(id))block {
    if (!object || !block) { return; }
    _TTDeallocObserver *observer = objc_getAssociatedObject(object, TTDeallocObserverAssociationKey);
    if (!observer) {
        observer = [[_TTDeallocObserver alloc] init];
        observer.object = object;
        objc_setAssociatedObject(object, TTDeallocObserverAssociationKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (observer.blocks) {
        [observer.blocks addObject:block];
    } else {
        if (observer.block) {
            observer.blocks = [NSMutableSet set];
            [observer.blocks addObject:observer.block];
            [observer.blocks addObject:block];
            observer.block = nil;
        } else {
            observer.block = block;
        }
    }
}
- (void)dealloc {
    [self.blocks enumerateObjectsUsingBlock:^(void(^block)(id), BOOL * _Nonnull stop) {
        block(self.object);
    }];
    !_block ?: _block(self.object);
    self.blocks = nil;
    self.block = nil;
}
@end

@interface _TTKVOObserver : NSObject

@property (nonatomic, assign) id object; // 如果指定为weak，在dealloc的时候object就已经释放了
@property (nonatomic, strong) NSMutableDictionary *keyAndBlocksMap;

@end

@implementation _TTKVOObserver

+ (void)observeObject:(id)object forKeyPath:(NSString *)keyPath context:(nullable void *)context changed:(TTObserveChangedBlock)changed {
    _TTKVOObserver *observer = objc_getAssociatedObject(object, TTKVOObserverAssociationKey);
    if (!observer) {
        observer = [[_TTKVOObserver alloc] init];
        observer.object = object;
        objc_setAssociatedObject(object, TTKVOObserverAssociationKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableSet *blocks = observer.keyAndBlocksMap[keyPath];
    if (![observer.keyAndBlocksMap.allKeys containsObject:keyPath]) {
        [object addObserver:observer
                 forKeyPath:keyPath
                    options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                    context:context];
        blocks = [NSMutableSet set];
        observer.keyAndBlocksMap[keyPath] = blocks;
    }
    [blocks addObject:changed];
}

+ (void)stopObserveObject:(id)object forKeyPath:(NSString *)keyPath {
    _TTKVOObserver *observer = objc_getAssociatedObject(object, TTKVOObserverAssociationKey);
    if ([observer.keyAndBlocksMap.allKeys containsObject:keyPath]) {
        [object removeObserver:object forKeyPath:keyPath];
        observer.keyAndBlocksMap[keyPath] = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![self.keyAndBlocksMap.allKeys containsObject:keyPath]) { return; }

    id newData = change[NSKeyValueChangeNewKey];
    id oldData = change[NSKeyValueChangeOldKey];
    NSMutableSet *blocks = self.keyAndBlocksMap[keyPath];
    for (TTObserveChangedBlock changed in blocks) {
        changed(newData, oldData, context);
    }
}

- (void)dealloc {
    if (self.object && self.keyAndBlocksMap.count) {
        [self.keyAndBlocksMap enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.object removeObserver:self forKeyPath:keyPath];
        }];
    }
}

- (NSMutableDictionary *)keyAndBlocksMap {
    if (!_keyAndBlocksMap) {
        _keyAndBlocksMap = [NSMutableDictionary dictionary];
    }
    return _keyAndBlocksMap;
}

@end

@implementation NSObject (TTUtil)

- (void)tt_setAssociateWeakObject:(id)object forKey:(const void *)key {
    if (!key) { return; }
    if (object) {
        _TTWeakReference *weakReference = [[_TTWeakReference alloc] init];
        weakReference.weakValue = object;
        objc_setAssociatedObject(self, key, weakReference, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id)tt_associateWeakObjectForKey:(const void *)key {
    if (!key) { return nil; }
    _TTWeakReference *weakReference = objc_getAssociatedObject(self, key);
    return weakReference.weakValue;
}

- (void)tt_observeObject:(id)object forKeyPath:(NSString *)keyPath context:(void *)context changed:(TTObserveChangedBlock)changed {
    if (!object || !keyPath.length || !changed) { return; }
    [_TTKVOObserver observeObject:object forKeyPath:keyPath context:context changed:changed];
}

- (void)tt_stopObserveObject:(id)object forKeyPath:(NSString *)keyPath {
    if (!object || !keyPath.length) { return; }
    [_TTKVOObserver stopObserveObject:object forKeyPath:keyPath];
}

- (id)tt_performSelectorWithArgs:(SEL)sel, ...{
    va_list args;
    va_start(args, sel);
    NSInvocation *invocation = [NSInvocation tt_invocationWithTarget:self selector:sel args:args];
    [invocation invoke];
    id ret = [invocation tt_returnValue];
    va_end(args);
    return ret;
}

- (void)tt_invokeInvocation:(NSInvocation *)invocation {
    [invocation invoke];
}

- (id)tt_performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ... {
    va_list args;
    va_start(args, sel);
    NSInvocation *invocation = [NSInvocation tt_invocationWithTarget:self selector:sel args:args];
    va_end(args);
    if (!invocation) { return nil; }
    [invocation retainArguments];
    [self performSelector:@selector(tt_invokeInvocation:) withObject:invocation afterDelay:delay];
    return invocation;
}

- (void)tt_cancelPreviousPerformRequestWithObject:(id)object {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tt_invokeInvocation:) object:object];
}

- (id)tt_performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...{
    va_list args;
    va_start(args, sel);
    NSInvocation *invocation = [NSInvocation tt_invocationWithTarget:self selector:sel args:args];
    if (!wait) [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
    return wait ? [invocation tt_returnValue] : nil;
}

- (id)tt_performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thr waitUntilDone:(BOOL)wait, ...{
    va_list args;
    va_start(args, sel);
    NSInvocation *invocation = [NSInvocation tt_invocationWithTarget:self selector:sel args:args];
    if (!wait) [invocation retainArguments];
    [invocation performSelector:@selector(invoke) onThread:thr withObject:nil waitUntilDone:wait];
    return wait ? [invocation tt_returnValue] : nil;
}

- (void)tt_performSelectorWithArgsInBackground:(SEL)sel, ...{
    va_list args;
    va_start(args, sel);
    NSInvocation *invocation = [NSInvocation tt_invocationWithTarget:self selector:sel args:args];
    [invocation performSelectorInBackground:@selector(invoke) withObject:nil];
}

- (void)tt_scheduleDeallocedBlock:(void (^)(id _Nonnull))block {
    [_TTDeallocObserver observeDeallocOfObject:self block:block];
}

- (NSString *)tt_debugAddress {
    return [NSString stringWithFormat:@"%p", self];
}

- (NSString *)tt_classHierarchy {
    NSMutableString *hierachy = [NSMutableString string];
    Class class = self.class;
    while (class) {
        if (hierachy.length) {
            [hierachy appendFormat:@" < %@", NSStringFromClass(class)];
        } else {
            [hierachy appendFormat:@"%@", NSStringFromClass(class)];
        }
        class = [class superclass];
    }
    return hierachy.copy;
}

@end
