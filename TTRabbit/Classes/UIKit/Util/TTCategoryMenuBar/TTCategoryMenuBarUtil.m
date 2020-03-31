//
//  TTCategoryMenuBarUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/7/2.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTCategoryMenuBarUtil.h"

const CGFloat TTCategoryMenuBarHeight = 44;
const CGFloat TTCategoryMenuBarOptionTailIndent = 10;
const CGFloat TTCategoryMenuBarDoneButtonHeight = 44;

@interface UIColor (TTCategoryMenuBar)
+ (UIColor *)TTCategoryMenuBar_colorWithHex:(uint32_t)hex;
@end

#define TTCategoryMenuBarColorFunc(name, hex) UIColor * name() { \
static UIColor *_##name; \
if (!_##name) { \
    _##name = [UIColor TTCategoryMenuBar_colorWithHex:hex]; \
} \
return _##name; \
}

TTCategoryMenuBarColorFunc(TTCategoryMenuBarBgColor, 0xf5f5f5)
TTCategoryMenuBarColorFunc(TTCategoryMenuBarLineColor, 0xeeeeee)
TTCategoryMenuBarColorFunc(TTCategoryMenuBarBlackColor, 0x333333)
TTCategoryMenuBarColorFunc(TTCategoryMenuBarGrayColor, 0x666666)
TTCategoryMenuBarColorFunc(TTCategoryMenuBarBlueColor, 0x2684ff)

#undef TTCategoryMenuBarColorFunc

@implementation UIColor (TTCategoryMenuBar)

+ (UIColor *)TTCategoryMenuBar_colorWithHex:(uint32_t)hex {
    if (hex > 0xffffff) {
        return [UIColor TTCategoryMenuBar_colorWithARGBHex:hex];
    }
    return [self TTCategoryMenuBar_colorWithHex:hex andAlpha:1.0];
}

+ (UIColor *)TTCategoryMenuBar_colorWithARGBHex:(UInt32)hex {
    int red, green, blue, alpha;
    blue = hex & 0x000000FF;
    green = ((hex & 0x0000FF00) >> 8);
    red = ((hex & 0x00FF0000) >> 16);
    alpha = ((hex & 0xFF000000) >> 24);
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha/255.f];
}

+ (UIColor *)TTCategoryMenuBar_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

@end
