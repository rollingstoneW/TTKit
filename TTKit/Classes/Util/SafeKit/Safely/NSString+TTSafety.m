//
//  NSString+TTSafety.m
//  TTKit
//
//  TTKit on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSString+TTSafety.h"

@implementation NSString (TTSafety)

- (unichar)tt_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        return 0;
    }
    return [self characterAtIndex:index];
}

- (NSString *)tt_substringWithRange:(NSRange)range {
    if (range.location >= self.length) {
        return nil;
    }
    if (range.location + range.length > self.length) {
        return [self substringFromIndex:range.location];
    }
    return [self substringWithRange:range];
}

@end

@implementation NSMutableString (TTSafety)

- (void)tt_appendString:(NSString *)aString {
    if (!aString) {
        return;
    }
    [self appendString:aString];
}

- (void)tt_setString:(NSString *)aString {
    if (!aString) {
        return;
    }
    [self setString:aString];
}

- (void)tt_insertString:(NSString *)aString atIndex:(NSUInteger)index {
    if (index > [self length] || !aString) {
        return;
    }
    [self insertString:aString atIndex:index];
}

@end
