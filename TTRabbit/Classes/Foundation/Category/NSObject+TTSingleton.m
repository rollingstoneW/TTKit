//
//  NSObject+TTSingleton.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSObject+TTSingleton.h"

static NSLock *_TTSingletonLock;

@implementation NSObject (TTSingleton)

+ (instancetype)getInstance {
    return nil;
}

+ (instancetype)sharedInstance {
    NSMutableDictionary *_globleInstanceMap = [self _globleInstanceMap];
    NSString *className = NSStringFromClass(self);
    [_TTSingletonLock lock];
    id instance = [[self _globleInstanceMap] objectForKey:className];
    if (instance) {
        [_TTSingletonLock unlock];
        return instance;
    }
    instance = [self getInstance] ?: [[self alloc] init];
    [[self _globleInstanceMap] setValue:instance forKey:className];
    [_TTSingletonLock unlock];
    return instance;
}

+ (void)destorySharedInstance {
    NSString *className = NSStringFromClass(self);
    [_TTSingletonLock lock];
    [[self _globleInstanceMap] removeObjectForKey:className];
    [_TTSingletonLock unlock];
}

+ (NSMutableDictionary *)_globleInstanceMap {
    static NSMutableDictionary *_globleInstanceMap = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _globleInstanceMap = [NSMutableDictionary dictionary];
        _TTSingletonLock = [[NSLock alloc] init];
    });
    return _globleInstanceMap;
}

@end
