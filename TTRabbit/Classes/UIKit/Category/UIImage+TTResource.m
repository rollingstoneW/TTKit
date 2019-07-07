//
//  UIImage+TTResource.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/4.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIImage+TTResource.h"
#import "TTMacros.h"
#import "NSBundle+TTUtil.h"

@implementation UIImage (TTResource)

+ (nullable UIImage *)tt_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [self imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [self imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
#else
    if ([self respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [self imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [self imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
    }
#endif
}

+ (nullable UIImage *)tt_imageNamed:(NSString *_Nullable)name bundle:(NSBundle *)bundle{
    name = [name stringByDeletingPathExtension];
    UIImage *image;
    if (bundle) {
        image = [self tt_imageNamed:name inBundle:bundle];
        if(image) {
            return image;
        }
    }
    image = [self imageNamed:name];
    return image;
}

+ (UIImage *)tt_imageWithContentsOfName:(NSString *)name {
    return [self tt_imageWithContentsOfName:name bundle:[NSBundle mainBundle]];
}

+ (UIImage *)tt_imageWithContentsOfName:(NSString *)name bundle:(NSBundle *)bundle {
#define FindImage \
UIImage *image = [self tt_imageWithContentsOfRealName:imageName type:type inBundle:bundle]; \
if (image) { \
return image; \
} \

    if (!name.length || !bundle) {
        return nil;
    }
    
    NSString *type = name.pathExtension.length ? name.pathExtension : @"png";
    NSString *imageName = [name stringByDeletingPathExtension];
    
    BOOL hasScale = [imageName containsString:@"@"] && [imageName hasSuffix:@"x"];
    if (!hasScale) {
        NSString *imageNameWithoutScale = imageName;
        NSInteger scale = [UIScreen mainScreen].scale;
        // 升分辨率查找
        while (scale <= 3) {
            imageName = [self tt_transferImageName:imageNameWithoutScale withScale:scale];
            FindImage
            scale ++;
        }
        scale = [UIScreen mainScreen].scale - 1;
        // 降分辨率查找
        while (scale > 0) {
            imageName = [self tt_transferImageName:imageNameWithoutScale withScale:scale];
            FindImage
            scale --;
        }
    } else {
        FindImage
    }
    return nil;
    
#undef FindImage
}

+ (UIImage *)tt_imageWithContentsOfRealName:(NSString *)imageName type:(NSString *)type inBundle:(NSBundle *)bundle {
    NSString *path = [bundle.resourcePath stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        path = [bundle pathForResource:imageName ofType:type];
        if (path) {
            image = [UIImage imageWithContentsOfFile:path];
        }
    }
    return image;
}


+ (NSString *)tt_transferImageName:(NSString *)name withScale:(NSInteger)scale {
    if (scale == 1) {
        return name;
    }
    NSString *scaleComponent = [NSString stringWithFormat:@"@%ldx", scale];
    return [name stringByAppendingString:scaleComponent];
}

+ (nullable NSArray *)tt_frameImagesWithSelector:(SEL)selector
                                          prefix:(NSString *)prefix
                                numberPartLength:(NSInteger)numberPartLength
                                            from:(NSInteger)from
                                             end:(NSInteger)end {
    selector = selector ?: @selector(imageNamed:);
    if (![self respondsToSelector:selector] || !prefix.length || from < 0 || end < from) {
        return nil;
    }
    NSString *suffixFormat = (numberPartLength <= 1) ? @"%ld" : (numberPartLength == 2 ? @"%02ld" : @"%03ld");
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = from; i <= end; i++) {
        NSString *imageName = [prefix stringByAppendingFormat:suffixFormat, i];
        SuppressPerformSelectorLeakWarning(
                                           UIImage *image = [self performSelector:selector withObject:imageName];
                                           if (image) {
                                               [images addObject:image];
                                           }
                                           )
    }
    return images;
}

+ (NSArray *)tt_frameImagesWithSelector:(SEL)selector names:(NSArray *)names {
    selector = selector ?: @selector(imageNamed:);
    if (![self respondsToSelector:selector] || !names.count) {
        return nil;
    }
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *name in names) {
        SuppressPerformSelectorLeakWarning(
                                           UIImage *image = [self performSelector:selector withObject:name];
                                           if (images) {
                                               [images addObject:image];
                                           }
                                           )
    }
    return images;
}

@end
