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

/**
 根据keyPath取到字典类型的数据，如果为空则返回默认值def
 */
- (nullable NSDictionary *)tt_dictionaryValueForKeyPath:(NSString *)keyPath default:(nullable NSDictionary *)def;

/**
 根据keyPath取到数组类型的数据，如果为空则返回默认值def
 */
- (nullable NSArray *)tt_arrayValueForKeyPath:(NSString *)keyPath default:(nullable NSArray *)def;

/**
 根据keyPath取到NSNumber类型的数据，如果为空则返回默认值def
 */
- (nullable NSNumber *)tt_numberValueForKeyPath:(NSString *)keyPath default:(nullable NSNumber *)def;

/**
 根据keyPath取到NSString类型的数据，如果为空则返回默认值def
 */
- (nullable NSString *)tt_stringValueForKeyPath:(NSString *)keyPath default:(nullable NSString *)def;

/**
 根据keyPath取到bool类型的数据，如果为空则返回默认值def
 */
- (BOOL)tt_boolValueForKeyPath:(NSString *)keyPath default:(BOOL)def;

/**
 根据char取到NSNumber类型的数据，如果为空则返回默认值def
 */
- (char)tt_charValueForKeyPath:(NSString *)keyPath default:(char)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (unsigned char)tt_unsignedCharValueForKeyPath:(NSString *)keyPath default:(unsigned char)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (short)tt_shortValueForKeyPath:(NSString *)keyPath default:(short)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (unsigned short)tt_unsignedShortValueForKeyPath:(NSString *)keyPath default:(unsigned short)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (int)tt_intValueForKeyPath:(NSString *)keyPath default:(int)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (unsigned int)tt_unsignedIntValueForKeyPath:(NSString *)keyPath default:(unsigned int)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (long)tt_longValueForKeyPath:(NSString *)keyPath default:(long)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (unsigned long)tt_unsignedLongValueForKeyPath:(NSString *)keyPath default:(unsigned long)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (long long)tt_longLongValueForKeyPath:(NSString *)keyPath default:(long long)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (unsigned long long)tt_unsignedLongLongValueForKeyPath:(NSString *)keyPath default:(unsigned long long)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (float)tt_floatValueForKeyPath:(NSString *)keyPath default:(float)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (double)tt_doubleValueForKeyPath:(NSString *)keyPath default:(double)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (NSInteger)tt_integerValueForKeyPath:(NSString *)keyPath default:(NSInteger)def;

/**
 根据keyPath取到unsignedChar类型的数据，如果为空则返回默认值def
 */
- (NSUInteger)tt_unsignedIntegerValueForKeyPath:(NSString *)keyPath default:(NSUInteger)def;

/**
 合并两个字典，如果key重复，则用other里的value覆盖原value
 */
- (NSDictionary *)tt_dictionaryByMergingOtherUsingNew:(NSDictionary *)other;

/**
 合并两个字典
 如果key重复，若usingStrict为YES，则不添加other里key对应的value，否则添加other里key对应的value，若原value为数组，则直接添加进数组，否则原value变为包含原value和新value的数组。
 */
- (NSDictionary *)tt_dictionaryByMergingOtherCombined:(NSDictionary *)other usingStrict:(BOOL)usingStrict;

/**
 合并两个字典
 conflict：如何解决key重复的情况，如果返回newValue，则使用newValue，否则使用原value
 */
- (NSDictionary *)tt_dictionaryByMergingOther:(NSDictionary *)other conflict:(TTMergingConflict)conflict;

@end

NS_ASSUME_NONNULL_END
