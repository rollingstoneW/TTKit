//
//  NSFileManager+TTUtil.h
//  TTRabbit
//
//  Created by Rabbit on 2020/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (TTUtil)

+ (NSString * _Nullable)tt_fileSizeDescritionAtPath:(NSString *)path fileSize:(uint64_t * _Nullable)fileSize;

@end

NS_ASSUME_NONNULL_END
