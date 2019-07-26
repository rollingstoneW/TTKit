//
//  NSInvocation+TTUtil.h
//  TTRabbit
//
//  Created by weizhenning on 2019/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (TTUtil)

+ (instancetype)tt_invocationWithArgs:(id)target selector:(SEL)selector, ...;
+ (instancetype)tt_invocationWithTarget:(id)target selector:(SEL)selector args:(va_list)args;

- (id)tt_returnValue;
- (id)tt_argumentAtIndex:(NSUInteger)index;
- (NSArray *)tt_arguments;

@end

NS_ASSUME_NONNULL_END
