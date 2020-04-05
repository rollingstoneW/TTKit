//
//  NSDate+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (TTUtil)

// @"yyyy-MM-dd"
+ (NSString *)tt_nowStringFromDateFormat;

/// @"yyyy年MM月dd号"
+ (NSString *)tt_nowStringFromDateFormatChinese;

// @"MM-dd"
+ (NSString *)tt_nowStringFromShortDateFormat;

/// @"MM月dd号"
+ (NSString *)tt_nowStringFromShortDateFormatChinese;

// @"yyyyMMdd"
+ (NSString *)tt_nowStringFromDateWithOutDashFormat;

// @"yyyy年MM月"
+ (NSString *)tt_nowStringFromYearMonthFormat;

// @"HH:mm:ss"
+ (NSString *)tt_nowStringFromTimeFormat;

// @"HH:mm"
+ (NSString *)tt_nowStringFromHourMinuteFormat;

// @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)tt_nowStringFromTimestampFormat;

// @"yyyy-MM-dd HH:mm:ss:SSS"
+ (NSString *)tt_nowStringFromTimestampWithMsFormat;

// @"yyyy-MM-dd HH:mm"
+ (NSString *)tt_nowStringFromTimestampWithoutSecondFormat;

+ (nullable NSString *)tt_nowStringFromFormat:(NSString *)format;

/**
 当前月份的第一天
 */
- (nullable NSDate *)tt_firstDayOfMonth;

/**
 当前月份的最后一天
 */
- (nullable NSDate *)tt_lastDayOfMonth;

/**
 当前周的第一天
 */
- (nullable NSDate *)tt_firstDayOfWeek;

/**
 当前周的最后一天
 */
- (nullable NSDate *)tt_lastDayOfWeek;

/**
 当前周的中间的一天
 */
- (nullable NSDate *)tt_middleDayOfWeek;

/**
 当前月份有多少天
 */
- (NSInteger)tt_numberOfDaysInMonth;

+ (NSTimeInterval)tt_timeIntervalSince1970InCurrentZone;
+ (NSTimeInterval)tt_timeIntervalSince1970InShanghaiZone;

@end

NS_ASSUME_NONNULL_END
