//
//  TTUIKitFactory.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTUIKitFactory.h"
#import "UIColor+YYAdd.h"

@implementation UIView (TTFactory)
+ (UIView *)viewWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    return view;
}
+ (UIView *)EFEFEFLine {
    return [self viewWithColor:UIColorHex(0xEfEfEf)];
}
@end

@implementation UILabel (TTFactory)
+ (UILabel *)labelWithAttributedText:(NSAttributedString *)attributedText {
    UILabel *label = [[self alloc] init];
    label.attributedText = attributedText;
    return label;
}
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:nil font:font textColor:color alignment:NSTextAlignmentLeft numberOfLines:1];
}
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)lines {
    return [self labelWithText:nil font:font textColor:color alignment:alignment numberOfLines:lines];
}
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:text font:font textColor:color alignment:NSTextAlignmentLeft numberOfLines:1];
}
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)lines {
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    label.numberOfLines = lines;
    return label;
}
@end

@implementation UIButton (TTFactory)
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor {
    return [self buttonWithTitle:title font:font titleColor:titleColor image:nil];
}
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor image:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}
+ (UIButton *)buttonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector {
    return [self buttonWithImage:image selectedImage:nil target:target selector:selector];
}
+ (UIButton *)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selected target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selected forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithBgImage:(UIImage *)image target:(id)target selector:(SEL)selector {
    return [self buttonWithBgImage:image selectedImage:nil target:target selector:selector];
}
+ (UIButton *)buttonWithBgImage:(UIImage *)image selectedImage:(UIImage *)selected target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:selected forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithAttributedTitle:(NSAttributedString *)attributedTitle target:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end

@implementation UIColor (TTFactory)

+ (UIColor *)tt_colorWithHexString:(NSString *)hex {
    return [UIColor colorWithHexString:hex];
}

@end
