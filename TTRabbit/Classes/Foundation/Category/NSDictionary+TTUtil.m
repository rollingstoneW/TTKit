//
//  NSDictionary+TTUtil.m
//  TTRabbit
//
//  Created by rollingstoneW on 2019/11/1.
//

#import "NSDictionary+TTUtil.h"
#import "NSArray+TTUtil.h"

@implementation NSDictionary (TTUtil)

- (nullable NSDictionary *)tt_dictionaryValueForKey:(NSString *)key defaultValue:(nullable NSDictionary *)def {
    if (!key.length) {
        return def;
    }
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return def;
}

- (nullable NSArray *)tt_arrayValueForKey:(NSString *)key defaultValue:(nullable NSArray *)def {
    if (!key.length) {
        return def;
    }
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return def;
}

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
