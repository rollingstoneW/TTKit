//
//  NSArray+TTSafety.m
//  TTKit
//
//  TTKit on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSArray+TTSafety.h"

@implementation NSArray (TTSafety)

- (id)tt_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (id)tt_objectAtIndexedSubscript:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    return [self objectAtIndexedSubscript:index];
}

- (NSArray *)tt_arrayByAddingObject:(id)anObject {
    if (!anObject) {
        return self;
    }
    return [self arrayByAddingObject:anObject];
}

@end

@implementation NSMutableArray (TTSafety)

- (void)tt_addObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self addObject:anObject];
}

- (void)tt_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count] || !anObject) {
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)tt_removeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return;
    }
    return [self removeObjectAtIndex:index];
}

- (void)tt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count] || !anObject) {
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}

@end
