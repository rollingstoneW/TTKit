//
//  NSArray+TTUtil.m
//  TTRabbit
//
//  Created by rollingstoneW on 2019/11/13.
//

#import "NSArray+TTUtil.h"

@implementation NSArray (TTUtil)

- (NSArray *)tt_arrayByMergingOther:(NSArray *)other allowRepeat:(BOOL)allowRepeat {
    if (!other.count) {
        return self;
    }
    if (allowRepeat) {
        return [self arrayByAddingObjectsFromArray:other];
    }
    NSMutableArray *newArr = self.mutableCopy;
    [other enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }];
    return newArr;
}

@end
