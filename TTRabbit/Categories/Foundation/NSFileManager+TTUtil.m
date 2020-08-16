//
//  NSFileManager+TTUtil.m
//  TTRabbit
//
//  Created by Rabbit on 2020/7/21.
//

#import "NSFileManager+TTUtil.h"

@implementation NSFileManager (TTUtil)

+ (NSString *)tt_fileSizeDescritionAtPath:(NSString *)path fileSize:(uint64_t *)fileSize {
    if (!path.length) {
        return nil;
    }
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSNumber *fileSizeNumber = fileInfo[NSFileSize];
    if (!fileSizeNumber) {
        return nil;
    }
    *fileSize = fileSizeNumber.longLongValue;
    return [NSByteCountFormatter stringFromByteCount:*fileSize countStyle:NSByteCountFormatterCountStyleBinary];
}

@end
