//
//  NSString+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSString+SafeKit.h"
#import "NSObject+SafeKit.h"

@implementation NSString (SafeKit)

#pragma mark - NSString
- (unichar)safe_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        return 0;
    }
    return [self safe_characterAtIndex:index];
}

- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return @"";
    }
    return [self safe_substringWithRange:range];
}

#pragma mark - NSMutableString
- (void)safe_appendString:(NSString *)aString {
    if (!aString) {
        return;
    }
    [self safe_appendString:aString];
}

- (void)safe_setString:(NSString *)aString {
    if (!aString) {
        return;
    }
    [self safe_setString:aString];
}

- (void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)index {
    if (index > [self length]) {
        return;
    }
    if (!aString) {
        return;
    }

    [self safe_insertString:aString atIndex:index];
}

+ (void)makeSafe {
    // NSString
    [self safe_swizzleMethod:@selector(safe_characterAtIndex:) tarClass:@"__NSCFString" tarSel:@selector(characterAtIndex:)];
    [self safe_swizzleMethod:@selector(safe_substringWithRange:) tarClass:@"__NSCFString" tarSel:@selector(substringWithRange:)];

    // NSMutableString
    [self safe_swizzleMethod:@selector(safe_appendString:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
    [self safe_swizzleMethod:@selector(safe_setString:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
    [self safe_swizzleMethod:@selector(safe_insertString:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
}

@end
