//
//  NSDictionary+TTUtil.h
//  TTRabbit
//
//  Created by ZYB on 2019/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (TTUtil)

- (nullable NSDictionary *)dictionaryValueForKey:(NSString *)key defaultValue:(nullable NSDictionary *)def;

- (nullable NSArray *)arrayValueForKey:(NSString *)key defaultValue:(nullable NSArray *)def;

@end

NS_ASSUME_NONNULL_END
