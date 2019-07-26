//
//  NSDateFormatter+TTUtil.m
//  TTRabbit
//
//  Created by weizhenning on 2019/7/25.
//

#import "NSDateFormatter+TTUtil.h"

static NSLock *_TTDateFormatterLock;

@implementation NSDateFormatter (TTUtil)

+ (nullable instancetype)tt_formatterWithFormatAtomicly:(NSString *)format {
    if (!format.length) { return nil; }
    NSMutableDictionary *tt_dateFormatterCache = [self tt_dateFormatterCache];
    [_TTDateFormatterLock lock];
    NSDateFormatter *dateFormatter = tt_dateFormatterCache[format];
    if (dateFormatter) {
        [_TTDateFormatterLock unlock];
        return dateFormatter;
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    tt_dateFormatterCache[format] = dateFormatter;
    [_TTDateFormatterLock unlock];
    return dateFormatter;
}

+ (nullable instancetype)tt_formatterWithFormat:(NSString *)format {
    if (!format.length) { return nil; }
    NSMutableDictionary *tt_dateFormatterCache = [self tt_dateFormatterCache];
    NSDateFormatter *dateFormatter = tt_dateFormatterCache[format];
    if (dateFormatter) {
        return dateFormatter;
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    tt_dateFormatterCache[format] = dateFormatter;
    return dateFormatter;
}

+ (NSMutableDictionary *)tt_dateFormatterCache {
    static dispatch_once_t token;
    static NSMutableDictionary *tt_dateFormatterCache;
    dispatch_once(&token, ^{
        _TTDateFormatterLock = [[NSLock alloc] init];
        tt_dateFormatterCache = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [_TTDateFormatterLock lock];
            [tt_dateFormatterCache removeAllObjects];
            [_TTDateFormatterLock unlock];
        }];
    });
    return tt_dateFormatterCache;
}

+ (instancetype)tt_dateFormatter {
    return [self tt_formatterWithFormatAtomicly:@"yyyy-MM-dd"];
}

+ (instancetype)tt_dateFormatterChinese {
    return [self tt_formatterWithFormatAtomicly:@"yyyy年MM月dd日"];
}

+ (instancetype)tt_shortDateFormatter {
    return [self tt_formatterWithFormatAtomicly:@"MM-dd"];
}

+ (instancetype)tt_shortDateFormatterChinese {
    return [self tt_formatterWithFormatAtomicly:@"MM月dd号"];
}

+ (instancetype)tt_dateWithOutDashFormatter {
    return [self tt_formatterWithFormatAtomicly:@"yyyyMMdd"];
}

+ (instancetype)tt_yearMonthFormatter {
    return [self tt_formatterWithFormatAtomicly:@"yyyy年MM月"];
}

+ (instancetype)tt_timeFormatter {
    return [self tt_formatterWithFormatAtomicly:@"HH:mm:ss"];
}

+ (instancetype)tt_hourMinuteFormatter {
    return [self tt_formatterWithFormatAtomicly:@"HH:mm"];
}

+ (instancetype)tt_timestampFormatter {
    return [self tt_formatterWithFormatAtomicly:@"yyyy-MM-dd HH:mm:ss"];
}

+ (instancetype)tt_timestampWithMsFormatter {
    return [self tt_formatterWithFormatAtomicly:@"yyyy-MM-dd HH:mm:ss:SSS"];
}

+ (instancetype)tt_timestampWithoutSecondFormatter {
    return [self tt_formatterWithFormatAtomicly:@"yyyy-MM-dd HH:mm"];
}

@end
