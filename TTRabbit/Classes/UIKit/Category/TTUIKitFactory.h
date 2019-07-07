//
//  TTUIKitFactory.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 创建常用UI组件的一些便捷方法
 */
@interface UIView (TTFactory)
+ (UIView *)viewWithColor:(UIColor *)color;
+ (UIView *)EFEFEFLine;
@end

@interface UILabel (TTFactory)
+ (UILabel *)labelWithAttributedText:(NSAttributedString *)attributedText;
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;
+ (UILabel *)labelWithText:(NSString *)text
                      font:(UIFont *)font
                 textColor:(UIColor *)color
             textAlignment:(NSTextAlignment)textAlignment
             numberOfLines:(NSInteger)numberOfLines;
@end

@interface UIButton (TTFactory)
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor image:(UIImage *)image;
+ (UIButton *)buttonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;
+ (UIButton *)buttonWithAttributedTitle:(NSAttributedString *)attributedTitle target:(id)target selector:(SEL)selector;
@end

@interface UIColor (TTFactory)

+ (UIColor *)tt_colorWithHex:(uint32_t)hex;

@end

/**************************************************************
*                          Color                              *
**************************************************************/
#define kTTColor_Orange        [UIColor orangeColor]
#define kTTColor_Blue          [UIColor blueColor]
#define kTTColor_Green         [UIColor greenColor]
#define kTTColor_Red           [UIColor redColor]
#define kTTColor_Black         [UIColor blackColor]
#define kTTColor_White         [UIColor whiteColor]
#define kTTColor_Clear         [UIColor clearColor]
#define kTTColor_DimBackground [[UIColor blackColor] colorWithAlphaComponent:.6]

#define kTTColor_f2 [UIColor tt_colorWithHex:0xf2f2f2]
#define kTTColor_33 [UIColor tt_colorWithHex:0x333333]
#define kTTColor_66 [UIColor tt_colorWithHex:0x666666]
#define kTTColor_99 [UIColor tt_colorWithHex:0x999999]
#define kTTColor_aa [UIColor tt_colorWithHex:0xaaaaaa]
#define kTTColor_bb [UIColor tt_colorWithHex:0xbbbbbb]
#define kTTColor_cc [UIColor tt_colorWithHex:0xcccccc]
#define kTTColor_dd [UIColor tt_colorWithHex:0xdddddd]
#define kTTColor_d8 [UIColor tt_colorWithHex:0xd8d8d8]
#define kTTColor_f5 [UIColor tt_colorWithHex:0xf5f5f5]
#define kTTColor_e5 [UIColor tt_colorWithHex:0xe5e5e5]
#define kTTColor_f8 [UIColor tt_colorWithHex:0xf8f8f8]
#define kTTColor_f9 [UIColor tt_colorWithHex:0xf9f9f9]
#define kTTColor_f0 [UIColor tt_colorWithHex:0xf0f0f0]
#define kTTColor_fe [UIColor tt_colorWithHex:0xfefefe]

/**************************************************************
 *                          Font                              *
 **************************************************************/
#define kTTFont_24 [UIFont systemFontOfSize:24]
#define kTTFont_18 [UIFont systemFontOfSize:18]
#define kTTFont_16 [UIFont systemFontOfSize:16]
#define kTTFont_14 [UIFont systemFontOfSize:14]
#define kTTFont_12 [UIFont systemFontOfSize:12]
#define kTTFont_11 [UIFont systemFontOfSize:11]
#define kTTFont_10 [UIFont systemFontOfSize:10]
#define kTTFont_09 [UIFont systemFontOfSize:9]
#define kTTFont(size) [UIFont systemFontOfSize:size]
