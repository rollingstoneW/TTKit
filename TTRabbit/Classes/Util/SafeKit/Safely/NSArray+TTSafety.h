//
//  NSArray+TTSafety.h
//  TTKit
//
//  TTKit on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (TTSafety)

- (id)tt_objectAtIndex:(NSUInteger)index;
- (id)tt_objectAtIndexedSubscript:(NSUInteger)index;
- (NSArray *)tt_arrayByAddingObject:(id)anObject;

@end

@interface NSMutableArray (TTSafety)

- (void)tt_addObject:(id)anObject;
- (void)tt_insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)tt_removeObjectAtIndex:(NSUInteger)index;
- (void)tt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
