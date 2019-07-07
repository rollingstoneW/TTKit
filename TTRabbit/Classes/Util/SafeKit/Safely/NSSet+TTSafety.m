//
//  NSSet+TTSafety.m
//  TTKit
//
//  TTKit on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSSet+TTSafety.h"

@implementation NSSet (TTSafety)

+ (instancetype)tt_setWithObject:(id)anObject {
    if (!anObject) {
        return [self set];
    }
    return [self setWithObject:anObject];
}

- (instancetype)tt_setByAddingObject:(id)anObject {
    if (!anObject) {
        return self;
    }
    return [self setByAddingObject:anObject];
}

@end

@implementation NSMutableSet (TTSafety)

- (void)tt_addObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self addObject:anObject];
}

- (void)tt_removeObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self removeObject:anObject];
}

@end
