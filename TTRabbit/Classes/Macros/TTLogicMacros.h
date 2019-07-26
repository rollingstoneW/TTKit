//
//  TTLogicMacros.h
//  Pods
//
//  Created by weizhenning on 2019/7/18.
//

#ifndef TTLogicMacros_h
#define TTLogicMacros_h

#import <objc/runtime.h>

#define TTReplaceNaN(x)                     (x = isnan(x) ? 0 : x)
#define TTReplaceNaNWithNumber(x,aNumber)   (x = isnan(x) ? aNumber : x)

#define TTNumberInRange(x, min, max)        MAX(MIN(max, x), min)
#define TTNumber2NewIfNotFound(x, new)      (x == NSNotFound ? new : x)
#define TTNumber2ZeroIfNotFound(x)          Number2NewIfNotFound(x, 0)

typedef void(^TTCompletionBlock)(__kindof id data, NSError *error);
#define TTSafeBlock(block, ...)            (!block ?: block(__VA_ARGS__))

#define TTSafePerformSelector(target, sel, ...) ([target respondsToSelector:sel] ? [target performSelectorWithArgs:sel, __VA_ARGS__] : nil)

// 退出当前大括弧作用域会调用此回掉
#define TTOnExit \
autoreleasepool {} \
__strong dispatch_block_t tt_exitBlock_##__LINE__ __attribute__((cleanup(tt_executeCleanupBlock), unused)) = ^
static inline void tt_executeCleanupBlock (__strong dispatch_block_t *block) {
    (*block)();
}

// 去除Warc-performSelector-leaks警告
#define TTSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0);

// 去除Wundeclared-selector警告
#define TTSuppressSelectorDeclaredWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0);

#pragma mark - Setter && Getter

#define TTSetterCondition(NAME, ...) if (_##NAME == NAME) { \
return; \
}\
{__VA_ARGS__; }\
_##NAME = NAME;

#define TTSetterEqualCondition(NAME, SEL, ...) if ([_##NAME SEL:NAME]) { \
return; \
}\
{__VA_ARGS__; }\
_##NAME = NAME;

#define TTGetterIMP(TYPE, NAME, ...) - (TYPE)NAME { \
if (!_##NAME) { \
_##NAME = __VA_ARGS__; \
} \
return _##NAME; \
}

#define TTGetterObjectIMP(NAME, ...) TTGetterIMP(id, NAME, __VA_ARGS__)
#define TTCapitalizeFirstChar(aString) if (aString.length) { \
return  [aString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[aString substringToIndex:1] capitalizedString]]; \
} else { \
return nil; \
}

#define TTSYNTH_DYNAMIC_PROPERTY_BOOLVALUE(_getter_, _setter_, _defaultValue_) \
- (void)_setter_ : (BOOL)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, @selector(_getter_), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (BOOL)_getter_ { \
NSNumber *value = objc_getAssociatedObject(self, @selector(_getter_)); \
if (!value && _defaultValue_) { \
value = @(_defaultValue_); \
[self _setter_:value]; \
} \
return value.boolValue; \
}

#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE2(_getter_, _setter_, _type_, _defaultValue_) TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _type_, _defaultValue_)
#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE3(_getter_, _setter_, _type_, _selector_) TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _selector_, 0)
#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE4(_getter_, _setter_, _type_) TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _type_, 0)

#define TTSYNTH_DYNAMIC_PROPERTY_NSVALUE(_getter_, _setter_, _type_, _selector_, _defaultValue_) \
- (void)_setter_:(_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, @selector(_getter_), @(object), OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
NSNumber *value = objc_getAssociatedObject(self, _cmd); \
if (!value && _defaultValue_) { \
value = @(_defaultValue_); \
[self _setter_:_defaultValue_]; \
} \
return value._selector_; \
}

#endif /* TTLogicMacros_h */
