//
//  NSDictionary+TTUtil.m
//  TTRabbit
//
//  Created by rollingstoneW on 2019/11/1.
//

#import "NSDictionary+TTUtil.h"

@implementation NSDictionary (TTUtil)

- (nullable NSDictionary *)dictionaryValueForKey:(NSString *)key defaultValue:(nullable NSDictionary *)def {
    if (!key.length) {
        return def;
    }
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return def;
}

- (nullable NSArray *)arrayValueForKey:(NSString *)key defaultValue:(nullable NSArray *)def {
    if (!key.length) {
        return def;
    }
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return def;
}

@end
