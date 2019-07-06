//
//  NSArray+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-2-28.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSArray+SafeKit.h"
#import "NSObject+SafeKit.h"

@implementation NSArray (SafeKit)

#pragma mark - NSArray
- (instancetype)initWithObjects_safe:(id *)objects count:(NSUInteger)cnt {
    NSUInteger newCnt = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (!objects[i]) {
            break;
        }
        newCnt++;
    }
    self = [self initWithObjects_safe:objects count:newCnt];
    return self;
}

- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (id)safe_objectAtIndexedSubscript:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:index];
}

- (id)safe_objectAtIndexForNSArray0:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    return [self safe_objectAtIndexForNSArray0:index];
}

- (NSArray *)safe_arrayByAddingObject:(id)anObject {
    if (!anObject) {
        return self;
    }
    return [self safe_arrayByAddingObject:anObject];
}

#pragma mark - NSMutableArray
- (void)safe_addObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self safe_addObject:anObject];
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count]) {
        return;
    }
    if (!anObject) {
        return;
    }
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return;
    }
    return [self safe_removeObjectAtIndex:index];
}
- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count]) {
        return;
    }
    if (!anObject) {
        return;
    }
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}

+ (void)makeSafe {
    // NSArray
    [self safe_swizzleMethod:@selector(initWithObjects_safe:count:) tarClass:@"__NSPlaceholderArray" tarSel:@selector(initWithObjects:count:)];
    [self safe_swizzleMethod:@selector(safe_objectAtIndex:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
    [self safe_swizzleMethod:@selector(safe_arrayByAddingObject:) tarClass:@"__NSArrayI" tarSel:@selector(arrayByAddingObject:)];

    // FIXED: ios 11 crash: index 0 beyond bounds for empty array
    [self safe_swizzleMethod:@selector(safe_objectAtIndexedSubscript:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndexedSubscript:)];
    [self safe_swizzleMethod:@selector(safe_objectAtIndexForNSArray0:) tarClass:@"__NSArray0" tarSel:@selector(objectAtIndex:)];

    // NSMutableArray
    [self safe_swizzleMethod:@selector(safe_addObject:) tarClass:@"__NSArrayM" tarSel:@selector(addObject:)];
    [self safe_swizzleMethod:@selector(safe_insertObject:atIndex:) tarClass:@"__NSArrayM" tarSel:@selector(insertObject:atIndex:)];
    [self safe_swizzleMethod:@selector(safe_removeObjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
    [self safe_swizzleMethod:@selector(safe_replaceObjectAtIndex:withObject:) tarClass:@"__NSArrayM" tarSel:@selector(replaceObjectAtIndex:withObject:)];
}

@end

