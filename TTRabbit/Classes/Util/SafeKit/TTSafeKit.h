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

@interface TTSafeKit : NSObject

+ (void)makeSafeUseRuntime;

@end
