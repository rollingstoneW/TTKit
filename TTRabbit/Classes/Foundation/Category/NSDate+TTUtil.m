//
//  NSDate+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSDate+TTUtil.h"
#import <objc/runtime.h>

@implementation NSDate (TTUtil)

- (nullable NSDate *)tt_firstDayOfMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:self];
    components.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (nullable NSDate *)tt_lastDayOfMonth {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:self];
    components.month++;
    components.day = 0;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (nullable NSDate *)tt_firstDayOfWeek {
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *components = self.privateComponents;
    components.day = - (weekdayComponents.weekday - [NSCalendar currentCalendar].firstWeekday);
    components.day = (components.day-7) % 7;
    NSDate *tt_firstDayOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    tt_firstDayOfWeek = [[NSCalendar currentCalendar] dateBySettingHour:0 minute:0 second:0 ofDate:tt_firstDayOfWeek options:0];
    components.day = NSIntegerMax;
    return tt_firstDayOfWeek;
}

- (nullable NSDate *)tt_lastDayOfWeek {
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *components = self.privateComponents;
    components.day = - (weekdayComponents.weekday - [NSCalendar currentCalendar].firstWeekday);
    components.day = (components.day-7) % 7 + 6;
    NSDate *tt_lastDayOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    tt_lastDayOfWeek = [[NSCalendar currentCalendar] dateBySettingHour:0 minute:0 second:0 ofDate:tt_lastDayOfWeek options:0];
    components.day = NSIntegerMax;
    return tt_lastDayOfWeek;
}

- (nullable NSDate *)tt_middleDayOfWeek {
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToSubtract = self.privateComponents;
    componentsToSubtract.day = - (weekdayComponents.weekday - [NSCalendar currentCalendar].firstWeekday) + 3;
    NSDate *tt_middleDayOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:tt_middleDayOfWeek];
    tt_middleDayOfWeek = [[NSCalendar currentCalendar] dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    return tt_middleDayOfWeek;
}

- (NSInteger)tt_numberOfDaysInMonth {
    NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                       inUnit:NSCalendarUnitMonth
                                                      forDate:self];
    return days.length;
}

- (NSDateComponents *)privateComponents {
    NSDateComponents *components = objc_getAssociatedObject(self, _cmd);
    if (!components) {
        components = [[NSDateComponents alloc] init];
        objc_setAssociatedObject(self, _cmd, components, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return components;
}

@end
