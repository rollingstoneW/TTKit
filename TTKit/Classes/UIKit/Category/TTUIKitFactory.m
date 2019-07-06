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
    return [self labelWithText:nil font:font textColor:color textAlignment:NSTextAlignmentLeft numberOfLines:1];
}
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:text font:font textColor:color textAlignment:NSTextAlignmentLeft numberOfLines:1];
}
+ (UILabel *)labelWithText:(NSString *)text
                      font:(UIFont *)font
                 textColor:(UIColor *)color
             textAlignment:(NSTextAlignment)textAlignment
             numberOfLines:(NSInteger)numberOfLines {
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.textAlignment = textAlignment;
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
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

+ (UIColor *)tt_colorWithHex:(uint32_t)hex {
    return UIColorHex(hex);
}

@end
