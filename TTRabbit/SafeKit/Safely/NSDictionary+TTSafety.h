//
//  NSDictionary+TTSafety.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (TTSafety)

- (void)tt_removeObjectForKey:(NSString *)aKey;
- (void)tt_setObject:(id)anObject forKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
