//
//  TTSafeKit.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+TTSafety.h"
#import "NSArray+TTSafety.h"
#import "NSSet+TTSafety.h"
#import "NSString+TTSafety.h"

static inline NSString * TTSureString(NSString *src) {
    if ([src isKindOfClass:[NSString class]]) { return src; }
    if ([src isKindOfClass:[NSNumber class]]) { return [((NSNumber *)src) stringValue]; }
    return @"";
}
static inline NSArray * TTSureArray(NSArray *src) {
    if ([src isKindOfClass:[NSArray class]]) { return src; }
    return @[];
}
static inline NSDictionary * TTSureDictionary(NSDictionary *src) {
    if ([src isKindOfClass:[NSDictionary class]]) { return src; }
    return @{};
}

@interface TTSafeKit : NSObject

+ (void)makeSafeUseRuntime;

@end
