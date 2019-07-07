//
//  NSObject+TTSingleton.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSObject+TTSingleton.h"

#define TTSingletonLock(...) do { \
dispatch_semaphore_wait(_TTSingletonSemophore, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_TTSingletonSemophore); \
} while(0);
static dispatch_semaphore_t _TTSingletonSemophore;

@implementation NSObject (TTSingleton)

+ (instancetype)getInstance {
    return nil;
}

+ (instancetype)sharedInstance {
    NSString *className = NSStringFromClass(self);
    id instance = [[self _globleInstanceMap] objectForKey:className];
    if (instance) {
        return instance;
    }
    instance = [self getInstance];
    if (instance) {
        TTSingletonLock([[self _globleInstanceMap] setValue:instance forKey:className];);
        return instance;
    }
    instance = [[self alloc] init];
    TTSingletonLock([[self _globleInstanceMap] setValue:instance forKey:className];)
    return instance;
}

+ (void)destorySharedInstance {
    NSString *className = NSStringFromClass(self);
    TTSingletonLock([[self _globleInstanceMap] removeObjectForKey:className];)
}

+ (NSMutableDictionary *)_globleInstanceMap {
    static NSMutableDictionary *_globleInstanceMap = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _globleInstanceMap = [NSMutableDictionary dictionary];
        _TTSingletonSemophore = dispatch_semaphore_create(1);
    });
    return _globleInstanceMap;
}

@end
