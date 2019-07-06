//
//  NSSet+TTSafety.h
//  TTKit
//
//  TTKit on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet (TTSafety)

+ (instancetype)tt_setWithObject:(id)anObject;
- (instancetype)tt_setByAddingObject:(id)anObject;

@end

@interface NSMutableSet (TTSafety)

- (void)tt_addObject:(id)anObject;
- (void)tt_removeObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
