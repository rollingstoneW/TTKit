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

@end

NS_ASSUME_NONNULL_END
