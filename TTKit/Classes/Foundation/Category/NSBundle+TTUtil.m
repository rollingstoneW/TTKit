//
//  NSBundle+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "NSBundle+TTUtil.h"
#import "TTMacros.h"

@implementation NSBundle (TTUtil)

+ (UIImage *)tt_appIcon {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* image = [UIImage imageNamed:icon];
    if (!image){
        image = [UIImage imageNamed:@"AppIcon"];
    }
    return image;
}

+ (NSArray *)tt_alternateIconNames {
    if (@available(iOS 10.3, *)) {
        if (![UIApplication sharedApplication].supportsAlternateIcons) {
            return nil;
        }
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSDictionary *CFBundleAlternateIcons = [infoPlist valueForKeyPath:@"CFBundleIcons.CFBundleAlternateIcons"];
        NSMutableArray *iconNames = [NSMutableArray array];
        [CFBundleAlternateIcons enumerateKeysAndObjectsUsingBlock:^(NSString  *key, NSDictionary *obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]] && [obj.allKeys containsObject:@"CFBundleIconFiles"]) {
                [iconNames addObject:key];
            }
        }];
        return iconNames.copy;
    }
    return nil;
}

+ (NSString *)tt_alternateIconName {
    if (@available(iOS 10.3, *)) {
        if (![UIApplication sharedApplication].supportsAlternateIcons) {
            return nil;
        }
        return [UIApplication sharedApplication].alternateIconName;
    }
    return nil;
}

+ (void)tt_setAlternateIconName:(NSString *)alternateIconName completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    if (@available(iOS 10.3, *)) {
        if (![UIApplication sharedApplication].supportsAlternateIcons) {
            !completionHandler ?: completionHandler([NSError errorWithDomain:@"TTKit" code:0 userInfo:@{NSLocalizedDescriptionKey:@"不支持更换图标"}]);
            return;
        }
        [[UIApplication sharedApplication] setAlternateIconName:alternateIconName completionHandler:completionHandler];
    } else {
        !completionHandler ?: completionHandler([NSError errorWithDomain:@"TTKit" code:0 userInfo:@{NSLocalizedDescriptionKey:@"不支持更换图标"}]);
    }
}

+ (UIImage *)tt_launchImage {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSArray *imageArray = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imageArray){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(screenSize, imageSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            return [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return nil;
}

+ (NSString *)tt_appVersion {
    return [[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)tt_appDisplayName {
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"];
}

+ (void)tt_openSystemSetting {
    NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

    if ([[UIApplication sharedApplication] canOpenURL:URL]){
        [[UIApplication sharedApplication] openURL:URL];
    }
}

static NSString *const _HasInstalledKey = @"_HasInstalledKey";
+ (BOOL)tt_appIsFirstInstall {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:_HasInstalledKey];
}

+ (void)tt_unsetAppIsFirstInstall {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_HasInstalledKey];
}

+ (instancetype)tt_bundleWithName:(NSString *)name {
    if ([name isEqualToString:@"main"]) {
        return [self mainBundle];
    }
    NSString *resource = [name stringByDeletingPathExtension];
    NSString *type = name.pathExtension.length ? name.pathExtension : @"bundle";
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    if (!path) { return nil; }
    return [NSBundle bundleWithPath:path];
}

@end
