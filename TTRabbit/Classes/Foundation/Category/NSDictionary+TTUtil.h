//
//  NSDictionary+TTUtil.h
//  TTRabbit
//
//  Created by rollingstoneW on 2019/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^TTMergingConflict)(id newValue, id currentValue);

@interface NSDictionary (TTUtil)

- (BOOL)tt_boolValueForKeyPath:(NSString *)keyPath defaultValue:(BOOL)def;

- (long long)tt_longLongValueForKeyPath:(NSString *)keyPath defaultValue:(long long)def;
- (unsigned long long)tt_unsignedLongLongValueForKeyPath:(NSString *)keyPath defaultValue:(unsigned long long)def;

- (double)tt_doubleValueForKeyPath:(NSString *)keyPath defaultValue:(double)def;

- (NSInteger)tt_integerValueForKeyPath:(NSString *)keyPath defaultValue:(NSInteger)def;
- (NSUInteger)tt_unsignedIntegerValueForKeyPath:(NSString *)keyPath defaultValue:(NSUInteger)def;

- (nullable NSNumber *)tt_numberValueForKeyPath:(NSString *)keyPath defaultValue:(nullable NSNumber *)def;
- (nullable NSString *)stringValueForKeyPath:(NSString *)keyPath defaultValue:(nullable NSString *)def;

- (nullable NSDictionary *)tt_dictionaryValueForKey:(NSString *)key defaultValue:(nullable NSDictionary *)def;

- (nullable NSArray *)tt_arrayValueForKey:(NSString *)key defaultValue:(nullable NSArray *)def;

- (NSDictionary *)tt_dictionaryByMergingOtherUsingNew:(NSDictionary *)other;
- (NSDictionary *)tt_dictionaryByMergingOtherCombined:(NSDictionary *)other usingStrict:(BOOL)usingStrict;
- (NSDictionary *)tt_dictionaryByMergingOther:(NSDictionary *)other conflict:(TTMergingConflict)conflict;

@end

NS_ASSUME_NONNULL_END
