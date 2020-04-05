//
//  NSString+TTSafety.h
//  TTKit
//
//  TTKit on 2019/6/6.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TTSafety)

- (unichar)tt_characterAtIndex:(NSUInteger)index;
- (NSString *)tt_substringWithRange:(NSRange)range;

@end

@interface NSMutableString (TTSafety)

- (void)tt_appendString:(NSString *)aString;
- (void)tt_setString:(NSString *)aString ;
- (void)tt_insertString:(NSString *)aString atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
