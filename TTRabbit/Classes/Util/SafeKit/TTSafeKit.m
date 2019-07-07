//
//  TTSafeKit.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/18.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTSafeKit.h"
#import "NSObject+SafeKit.h"
#import "NSArray+SafeKit.h"
#import "NSDictionary+SafeKit.h"
#import "NSString+SafeKit.h"
#import "NSNumber+SafeKit.h"

@implementation TTSafeKit

+ (void)makeSafeUseRuntime {
    [NSObject makeSafe];
    [NSArray makeSafe];
    [NSDictionary makeSafe];
    [NSString makeSafe];
    [NSNumber makeSafe];
}

@end
