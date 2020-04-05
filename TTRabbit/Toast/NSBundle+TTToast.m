//
//  NSBundle+TTToast.m
//  TTRabbit
//
//  Created by 郭冰洁 on 2020/4/5.
//

#import "NSBundle+TTToast.h"

@implementation NSBundle (TTToast)

+ (NSBundle *)tt_toastBundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *name = @"TTToastBundle";
        NSString *resource = [name stringByDeletingPathExtension];
        NSString *type = name.pathExtension.length ? name.pathExtension : @"bundle";
        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
        if (!path) {
            // look for Frameworks
            NSString *TTRabbit = @"TTRabbit";
            NSString *frameworkName = [TTRabbit stringByAppendingPathExtension:@"framework"];
            path = [[NSBundle mainBundle].resourcePath stringByAppendingFormat:@"/Frameworks/%@", frameworkName];
            path = [path stringByAppendingFormat:@"/%@.bundle", name];
        }
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

@end
