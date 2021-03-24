//
//  NSDictionary+TTUtil.m
//  TTRabbit
//
//  Created by rollingstoneW on 2019/11/1.
//

#import "NSDictionary+TTUtil.h"
#import "NSArray+TTUtil.h"

@implementation NSDictionary (TTUtil)

/// Get a number value from 'id'.
static NSNumber *TTNSNumberFromString(NSString *value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    NSString *lower = ((NSString *)value).lowercaseString;
    if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
    if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
    if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
    if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
        return @(((NSString *)value).doubleValue);
    } else {
        return @(((NSString *)value).longLongValue);
    }
}

- (NSDictionary *)tt_dictionaryValueForKeyPath:(NSString *)keyPath default:(NSDictionary *)def {
    if (!keyPath.length) {
        return def;
    }
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    NSDictionary *curDict = self;
    for (NSInteger i = 0; i < keys.count; i++) {
        id value = [curDict objectForKey:keys[i]];
        if (![value isKindOfClass:[NSDictionary class]]) {
            return def;
        }
        curDict = value;
    }
    return curDict;
}

#define TTRETURN_OBJECTVALUE(_type_, ...) \
if (!keyPath.length) { \
    return def; \
} \
NSArray *keys = [keyPath componentsSeparatedByString:@"."]; \
if (keys.count == 1) { \
    id value = [self objectForKey:keys.firstObject]; \
    if ([value isKindOfClass:[_type_ class]]) { return value; } \
    __VA_ARGS__; \
    return def;\
} \
NSArray *newKeys = [keys subarrayWithRange:NSMakeRange(0, keys.count - 1)]; \
NSDictionary *preDict = [self tt_dictionaryValueForKeyPath:[newKeys componentsJoinedByString:@"."] default:nil]; \
if (!preDict) return nil; \
id value = [preDict objectForKey:keys.lastObject]; \
if ([value isKindOfClass:[_type_ class]]) { return value; } \
__VA_ARGS__; \
return def;\

- (nullable NSArray *)tt_arrayValueForKeyPath:(NSString *)keyPath default:(NSArray *)def {
    TTRETURN_OBJECTVALUE(NSArray, nil)
}

- (nullable NSNumber *)tt_numberValueForKeyPath:(NSString *)keyPath default:(nullable NSNumber *)def {
    TTRETURN_OBJECTVALUE(NSNumber, if ([value isKindOfClass:[NSString class]]) {
        return TTNSNumberFromString(value);
    })
}

- (nullable NSString *)tt_stringValueForKeyPath:(NSString *)keyPath default:(nullable NSString *)def {
    TTRETURN_OBJECTVALUE(NSString, if ([value isKindOfClass:[NSNumber class]]) {
        return [value description];
    })
}

#undef TTRETURN_OBJECTVALUE

#define TTRETURN_NUMBERVALUE(_type_) \
if (!keyPath.length) { \
    return def; \
} \
NSArray *keys = [keyPath componentsSeparatedByString:@"."]; \
if (keys.count == 1) { \
    id value = [self objectForKey:keys.firstObject]; \
    if ([value isKindOfClass:[NSNumber class]]) return [value _type_]; \
    if ([value isKindOfClass:[NSString class]]) return TTNSNumberFromString(value)._type_; \
    return def; \
} \
NSArray *newKeys = [keys subarrayWithRange:NSMakeRange(0, keys.count - 1)]; \
NSDictionary *preDict = [self tt_dictionaryValueForKeyPath:[newKeys componentsJoinedByString:@"."] default:nil]; \
id value = [preDict objectForKey:keys.lastObject]; \
if ([value isKindOfClass:[NSNumber class]]) return [value doubleValue]; \
if ([value isKindOfClass:[NSString class]]) return TTNSNumberFromString(value).doubleValue; \
return def;

- (BOOL)tt_boolValueForKeyPath:(NSString *)keyPath default:(BOOL)def {
    TTRETURN_NUMBERVALUE(boolValue)
}

- (char)tt_charValueForKeyPath:(NSString *)keyPath default:(char)def {
    TTRETURN_NUMBERVALUE(charValue)
}

- (unsigned char)tt_unsignedCharValueForKeyPath:(NSString *)keyPath default:(unsigned char)def {
    TTRETURN_NUMBERVALUE(unsignedCharValue)
}

- (short)tt_shortValueForKeyPath:(NSString *)keyPath default:(short)def {
    TTRETURN_NUMBERVALUE(shortValue)
}

- (unsigned short)tt_unsignedShortValueForKeyPath:(NSString *)keyPath default:(unsigned short)def {
    TTRETURN_NUMBERVALUE(unsignedShortValue)
}

- (int)tt_intValueForKeyPath:(NSString *)keyPath default:(int)def {
    TTRETURN_NUMBERVALUE(intValue)
}

- (unsigned int)tt_unsignedIntValueForKeyPath:(NSString *)keyPath default:(unsigned int)def {
    TTRETURN_NUMBERVALUE(unsignedIntValue)
}

- (long)tt_longValueForKeyPath:(NSString *)keyPath default:(long)def {
    TTRETURN_NUMBERVALUE(longValue)
}

- (unsigned long)tt_unsignedLongValueForKeyPath:(NSString *)keyPath default:(unsigned long)def {
    TTRETURN_NUMBERVALUE(unsignedLongValue)
}

- (long long)tt_longLongValueForKeyPath:(NSString *)keyPath default:(long long)def {
    TTRETURN_NUMBERVALUE(longLongValue)
}

- (unsigned long long)tt_unsignedLongLongValueForKeyPath:(NSString *)keyPath default:(unsigned long long)def {
    TTRETURN_NUMBERVALUE(unsignedLongLongValue)
}

- (float)tt_floatValueForKeyPath:(NSString *)keyPath default:(float)def {
    TTRETURN_NUMBERVALUE(floatValue)
}

- (double)tt_doubleValueForKeyPath:(NSString *)keyPath default:(double)def {
    TTRETURN_NUMBERVALUE(doubleValue)
}

- (NSInteger)tt_integerValueForKeyPath:(NSString *)keyPath default:(NSInteger)def {
    TTRETURN_NUMBERVALUE(integerValue)
}

- (NSUInteger)tt_unsignedIntegerValueForKeyPath:(NSString *)keyPath default:(NSUInteger)def {
    TTRETURN_NUMBERVALUE(unsignedIntegerValue)
}

#undef TTRETURN_NUMBERVALUE

- (NSDictionary *)tt_dictionaryByMergingOtherUsingNew:(NSDictionary *)other {
    return [self tt_dictionaryByMergingOther:other conflict:^id _Nullable(id  _Nonnull newValue, id  _Nonnull currentValue) {
        return newValue;
    }];
}

- (NSDictionary *)tt_dictionaryByMergingOtherCombined:(NSDictionary *)other usingStrict:(BOOL)usingStrict {
    return [self tt_dictionaryByMergingOther:other conflict:^id _Nullable(id  _Nonnull newValue, id  _Nonnull currentValue) {
        if ([currentValue isKindOfClass:[NSArray class]]) {
            if ([newValue isKindOfClass:[NSArray class]]) {
                return [currentValue tt_arrayByMergingOther:newValue allowRepeat:usingStrict];
            }
            if (usingStrict && [currentValue containsObject:newValue]) {
                return currentValue;
            }
            return [currentValue arrayByAddingObject:newValue];
        } else if ([currentValue isKindOfClass:[NSDictionary class]] && [newValue isKindOfClass:[NSDictionary class]]) {
            return [currentValue tt_dictionaryByMergingOtherCombined:newValue usingStrict:usingStrict];
        } else {
            if (usingStrict && [currentValue isEqual:newValue]) {
                return currentValue;
            }
            return @[currentValue, newValue];
        }
    }];
}

- (NSDictionary *)tt_dictionaryByMergingOther:(NSDictionary *)other conflict:(nonnull TTMergingConflict)conflict {
    if (!other || !other.count) {
        return self;
    }
    NSMutableDictionary *newDict = self.mutableCopy;
    [other enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id currentValue = newDict[key];
        if (currentValue && conflict) {
            newDict[key] = conflict(obj, currentValue);
        } else {
            newDict[key] = obj;
        }
    }];
    return newDict;
}

@end
