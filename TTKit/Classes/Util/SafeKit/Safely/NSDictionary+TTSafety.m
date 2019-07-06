//
//  NSDictionary+TTSafety.m
//  TTKit
//
//  TTKit on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSDictionary+TTSafety.h"

@implementation NSMutableDictionary (TTSafety)

- (void)tt_removeObjectForKey:(NSString *)aKey {
    if (!aKey) { return; }
    [self removeObjectForKey:aKey];
}
- (void)tt_setObject:(id)anObject forKey:(NSString *)aKey {
    if (!aKey || !anObject) { return; }
    [self setObject:anObject forKey:aKey];
}

@end
