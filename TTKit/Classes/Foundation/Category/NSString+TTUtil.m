//
//  NSString+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSString+TTUtil.h"
#import "NSString+YYAdd.h"
#import <CoreText/CoreText.h>

@implementation NSString (TTUtil)

- (NSRange)fullRange {
    return NSMakeRange(0, self.length);
}

- (void)convertHtmlStringToNSAttributedString:(void (^)(NSAttributedString *))block {
    if (!block) { return; }
    if (self.length || [self isEqualToString:@"(null)"]) {
        block([[NSAttributedString alloc] initWithString:@""]);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(attributedString.copy);
        });
    });
}

- (NSString *)stringByPrependingPrefixIfNeeded:(NSString *)prefix {
    if (!prefix.length || [self hasPrefix:prefix]) { return self; }
    return [prefix stringByAppendingString:self];
}

- (NSString *)stringByAppendingSuffixIfNeeded:(NSString *)suffix {
    if (!suffix.length || [self hasSuffix:suffix]) { return self; }
    return [self stringByAppendingString:suffix];
}

- (NSString *)stringByDeletingPrefix:(NSString *)prefix {
    if (!prefix.length || ![self hasPrefix:prefix]) { return self; }
    return [self substringFromIndex:[self rangeOfString:prefix].length];
}

- (NSString *)stringByDeletingSuffix:(NSString *)suffix {
    if (!suffix.length || ![self hasSuffix:suffix]) { return self; }
    return [self substringToIndex:[self rangeOfString:suffix options:NSBackwardsSearch].location];
}

- (NSString *)stringByTrimmingWhitespaceThroughout {
    NSMutableString *mtString = self.mutableCopy;
    [mtString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mtString.length)];
    return mtString;
}

- (NSString *)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font {
    if (!font) {
        return self;
    }
    CGFloat selfWidth = [self widthForFont:font];
    if (self.length == 0 || selfWidth <= width) {
        return self;
    }

    NSString *dotString = @"...";
    CGFloat dotLength = [dotString widthForFont:font];

    if (selfWidth < width * 2) {
        width -= dotLength;
        if (width <= 0) {
            return @"";
        }
        // 此时逆序效率更高
        NSMutableString *mutStr = self.mutableCopy;
        while ([mutStr widthForFont:font] > width) {
            [mutStr deleteCharactersInRange:NSMakeRange(mutStr.length - 1, 1)];
        }
        [mutStr appendString:dotString];
        return mutStr;
    } else {
        NSString *lastSubStr = nil;
        CGFloat lastSubWidth = 0;
        for (NSInteger i = 1; i < self.length; i++) {
            NSString *subStr = [self substringToIndex:i];
            CGFloat subWidth = [subStr widthForFont:font];
            // 超出，则取前一个子字符串
            if (subWidth > width) {
                return [lastSubStr stringByAppendingString:dotString];
            }
            lastSubStr = subStr;
            lastSubWidth = subWidth;
        }
        return @"";
    }
}

- (NSString *)stringByTruncatingToSize:(CGSize)size withTextAttributes:(NSDictionary *)attributes lastLineTailInset:(CGFloat)lastLineTailInset {
    UIFont *font = attributes[NSFontAttributeName];
    if (self.length == 0 || !font) {
        return self;
    }
    NSParagraphStyle *ps = attributes[NSParagraphStyleAttributeName];
    if (!ps || ps.lineBreakMode != NSLineBreakByCharWrapping) {
        NSMutableDictionary *newAttr = attributes.mutableCopy;
        NSMutableParagraphStyle *newPs = ps ? ps.mutableCopy : [[NSMutableParagraphStyle alloc] init];
        newPs.lineBreakMode = NSLineBreakByCharWrapping;
        newAttr[NSParagraphStyleAttributeName] = newPs;
        attributes = newAttr;
    }
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CGPathRef path = CGPathCreateWithRect((CGRect){.size = size}, nil);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFArrayRef CTLines = CTFrameGetLines(frame);

    NSInteger maxNumberOfLines = floor(size.height / font.lineHeight);
    CGFloat lastLineMaxWidth = size.width - lastLineTailInset;
    // 行数少于最小行数，直接return
    if (CFArrayGetCount(CTLines) < maxNumberOfLines) {
        CFRelease(framesetter);
        CFRelease(frame);
        CGPathRelease(path);
        return self;
    }

    CTLineRef lastCTLine = CFArrayGetValueAtIndex(CTLines, CFArrayGetCount(CTLines) - 1);
    CFRange lastLineCFRange = CTLineGetStringRange(lastCTLine);
    CGFloat lastLineWidth = CTLineGetTypographicBounds(lastCTLine, nil, nil, nil);
    NSRange lastLineRange = NSMakeRange(lastLineCFRange.location, lastLineCFRange.length);

    NSString *previousString = [self substringToIndex:lastLineRange.location];
    NSString *lastLineString = [self substringWithRange:lastLineRange];

    NSString *singleChar = @"正";
    CGFloat singleCharWidth = [singleChar widthForFont:font];

    if (lastLineWidth + singleCharWidth >= lastLineMaxWidth) {
        lastLineString = [[lastLineString stringByAppendingString:@"token"] stringByTruncatingToWidth:lastLineMaxWidth withFont:font];
    }

    CFRelease(framesetter);
    CFRelease(frame);
    CGPathRelease(path);

    return  [previousString stringByAppendingString:lastLineString];
}

- (NSString *)urlStringByAppendingKey:(NSString *)key value:(NSString *)value {
    if (!key.length || !value.length) { return self; }
    return [self urlStringByAppendingQueries:@{key : value}];
}

- (NSString *)urlStringByAppendingQueries:(NSDictionary *)queries {
    NSString *urlString = self;
    if ([urlString rangeOfString:@"?"].location == NSNotFound) {
        urlString = [urlString stringByAppendingString:@"?"];
    }
    // test?test=test
    if (![urlString hasSuffix:@"?"] && ![urlString hasSuffix:@"&"]) {
        urlString = [urlString stringByAppendingString:@"&"];
    }
    NSMutableArray *queriesArr = [NSMutableArray array];
    [queries enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString * obj, BOOL * _Nonnull stop) {
        [queriesArr addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    return [urlString stringByAppendingString:[queriesArr componentsJoinedByString:@"&"]];
}

- (NSString *)urlStringByQueryEncode {
    NSMutableCharacterSet *charSet = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [charSet addCharactersInString:@"#"];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:charSet];
}

- (NSDictionary *)urlQueries {
    NSRange range = [self rangeOfString:@"?"];
    if (!self.length || range.location == NSNotFound || range.location + range.length == self.length) { return nil; }

    NSMutableDictionary *urlQueries = [NSMutableDictionary dictionary];
    NSString *queryString = [self substringFromIndex:range.location + 1];
    NSArray *queries = [queryString componentsSeparatedByString:@"&"];
    [queries enumerateObjectsUsingBlock:^(NSString *query, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange equalRange = [query rangeOfString:@"="];
        if (equalRange.location == NSNotFound || equalRange.location == 0 || equalRange.location == query.length - 1) { return; }
        NSString *key = [[query substringToIndex:equalRange.location] stringByRemovingPercentEncoding];
        NSString *value = [[query substringFromIndex:equalRange.location + 1] stringByRemovingPercentEncoding];
        id exist = urlQueries[key];
        if (!exist) {
            urlQueries[key] = value;
            return;
        }
        if ([exist isKindOfClass:[NSMutableArray class]]) {
            [(NSMutableArray *)exist addObject:value];
        } else {
            urlQueries[key] = @[exist, value].mutableCopy;
        }
    }];
    return urlQueries;
}

- (BOOL)isChinese {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\u4e00-\u9fa5]+$"];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidEmail {
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPureInteger {
    NSString *pureIntegerRegex = @"^[0-9]+$";
    NSPredicate *pureIntegerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pureIntegerRegex];
    return [pureIntegerTest evaluateWithObject:self];
}

- (BOOL)isFloat {
    NSString *floatRegex = @"^(\\d*\\.)?\\d+$";
    NSPredicate *floatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", floatRegex];
    return [floatTest evaluateWithObject:self];
}

- (BOOL)isValidHttpURL {
    NSString *urlRegEx =
    @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)isValidQQ {
    NSString *urlRegEx =
    @"/^\\s*[.0-9]{5,11}\\s*$/";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

/**
 *  弱验证，只验证开头两位和总长度是11位
*/
- (BOOL)isValidPhoneNumber {
    NSString *COMMON = @"^1[3|4|5|7|8][0-9]{9}$";
    NSPredicate *regexTestPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", COMMON];
    if ([regexTestPhone evaluateWithObject:self] == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isValidWXNumber {
    NSString *COMMON = @"^[a-zA-Z0-9]{1}[-_a-zA-Z0-9]{5,19}+$";
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", COMMON];
    return  [regex evaluateWithObject:self];
}

+ (NSString *)fileSizeStringWithByteCount:(long long)byteCount {
    return [NSByteCountFormatter stringFromByteCount:byteCount countStyle:NSByteCountFormatterCountStyleBinary];
}

+ (NSString *)countdownStringWithInteval:(NSTimeInterval)interval {
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    return [formatter stringFromTimeInterval:interval];
}

+ (NSString *)decimalFormatedStringWithNumber:(CGFloat)number {
    NSNumber *num = [NSNumber numberWithFloat:number];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:num];
}

@end
