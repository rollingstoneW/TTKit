//
//  NSDateFormatter+TTUtil.h
//  TTRabbit
//
//  Created by rollingstoneW on 2019/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (TTUtil)

+ (nullable instancetype)tt_formatterWithFormatAtomicly:(NSString *)format;
+ (nullable instancetype)tt_formatterWithFormat:(NSString *)format;

// @"yyyy-MM-dd"
+ (instancetype)tt_dateFormatter;

// @"yyyy年MM月dd日"
+ (instancetype)tt_dateFormatterChinese;

// @"MM-dd"
+ (instancetype)tt_shortDateFormatter;

/// @"MM月dd号"
+ (instancetype)tt_shortDateFormatterChinese;

// @"yyyyMMdd"
+ (instancetype)tt_dateWithOutDashFormatter;

// @"yyyy年MM月"
+ (instancetype)tt_yearMonthFormatter;

// @"HH:mm:ss"
+ (instancetype)tt_timeFormatter;

// @"HH:mm"
+ (instancetype)tt_hourMinuteFormatter;

// @"yyyy-MM-dd HH:mm:ss"
+ (instancetype)tt_timestampFormatter;

// @"yyyy-MM-dd HH:mm:ss:SSS"
+ (instancetype)tt_timestampWithMsFormatter;

// @"yyyy-MM-dd HH:mm"
+ (instancetype)tt_timestampWithoutSecondFormatter;

@end

NS_ASSUME_NONNULL_END
