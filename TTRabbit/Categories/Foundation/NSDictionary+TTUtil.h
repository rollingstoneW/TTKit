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

- (nullable NSDictionary *)tt_dictionaryValueForKey:(NSString *)key defaultValue:(nullable NSDictionary *)def;

- (nullable NSArray *)tt_arrayValueForKey:(NSString *)key defaultValue:(nullable NSArray *)def;

- (NSDictionary *)tt_dictionaryByMergingOtherUsingNew:(NSDictionary *)other;
- (NSDictionary *)tt_dictionaryByMergingOtherCombined:(NSDictionary *)other usingStrict:(BOOL)usingStrict;
- (NSDictionary *)tt_dictionaryByMergingOther:(NSDictionary *)other conflict:(TTMergingConflict)conflict;

@end

NS_ASSUME_NONNULL_END
