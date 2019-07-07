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

@end
