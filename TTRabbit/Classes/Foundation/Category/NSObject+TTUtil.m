//
//  NSObject+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSObject+TTUtil.h"
#import <objc/runtime.h>

@interface _TTWeakReference : NSObject
@property (nonatomic, weak) id weakValue;
@end
@implementation _TTWeakReference
@end

static const void * TTKVOObserverAssociationKey = &TTKVOObserverAssociationKey;

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

- (NSString *)tt_debugAddress {
    return [NSString stringWithFormat:@"%p", self];
}

@end
