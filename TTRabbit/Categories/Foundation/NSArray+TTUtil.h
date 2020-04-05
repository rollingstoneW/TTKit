//
//  NSArray+TTUtil.h
//  TTRabbit
//
//  Created by ZYB on 2019/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (TTUtil)

- (NSArray *)tt_arrayByMergingOther:(NSArray *)other allowRepeat:(BOOL)allowRepeat;

@end

NS_ASSUME_NONNULL_END
