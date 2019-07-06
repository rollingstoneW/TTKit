//
//  NSObject+swizzle.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSObject+SafeKit.h"
#import <objc/runtime.h>

static inline id fakeIMP(id sender,SEL sel,...){
    return nil;
}
@interface _TTSafeTarget : NSObject
@end
@implementation _TTSafeTarget
-(instancetype)initWithSelector:(SEL)aSelector className:(NSString *)className {
    self = [super init];
    if (self) {
//        NSLog(@"\n-----------------------\n%@ dose not recognizer selector %@\n%@\n-----------------------", className, NSStringFromSelector(aSelector), [NSThread callStackSymbols]);
        class_addMethod([self class], aSelector, (IMP)fakeIMP, NULL);
    }
    return self;
}
@end

@implementation NSObject(Swizzle)

+ (void)safe_swizzleMethod:(SEL)srcSel tarSel:(SEL)tarSel{
    Class clazz = [self class];
    [self safe_swizzleMethod:clazz srcSel:srcSel tarClass:clazz tarSel:tarSel];
}

+ (void)safe_swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel{
    if (!tarClassName) {
        return;
    }
    Class srcClass = [self class];
    Class tarClass = NSClassFromString(tarClassName);
    [self safe_swizzleMethod:srcClass srcSel:srcSel tarClass:tarClass tarSel:tarSel];
}

+ (void)safe_swizzleMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel{
    if (!srcClass || !srcSel || !tarClass || !tarSel) {
        return;
    }

    Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
    Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
    method_exchangeImplementations(srcMethod, tarMethod);
}

+ (void)makeSafe {
    [self safe_swizzleMethod:@selector(forwardingTargetForSelector:) tarSel:@selector(safe_forwardingTargetForSelector:)];
    [object_getClass(self) safe_swizzleMethod:@selector(forwardingTargetForSelector:) tarSel:@selector(safe_forwardingTargetForSelector:)];
}

- (id)safe_forwardingTargetForSelector:(SEL)aSelector {
    if ([self isKindOfClass:NSClassFromString([@"_UI" stringByAppendingString:@"Appearance"])]) {
        return [self safe_forwardingTargetForSelector:aSelector];
    }
    if (![self respondsToSelector:aSelector]) {
        return [[_TTSafeTarget alloc] initWithSelector:aSelector className:NSStringFromClass(self.class)];
    }
    return [self safe_forwardingTargetForSelector:aSelector];
}

+ (id)safe_forwardingTargetForSelector:(SEL)aSelector {
    if ([self isKindOfClass:NSClassFromString([@"_UI" stringByAppendingString:@"Appearance"])]) {
        return [self safe_forwardingTargetForSelector:aSelector];
    }
    if (![self respondsToSelector:aSelector]) {
        return [[_TTSafeTarget alloc] initWithSelector:aSelector className:NSStringFromClass(self)];
    }
    return [self safe_forwardingTargetForSelector:aSelector];
}

@end
