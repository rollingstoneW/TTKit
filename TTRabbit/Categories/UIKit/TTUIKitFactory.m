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
+ (instancetype)viewWithColor:(UIColor *)color {
    UIView *view = [[self alloc] init];
    view.backgroundColor = color;
    return view;
}
+ (instancetype)EFEFEFLine {
    return [self viewWithColor:UIColorHex(0xEfEfEf)];
}
@end

@implementation UILabel (TTFactory)
+ (instancetype)labelWithAttributedText:(NSAttributedString *)attributedText {
    UILabel *label = [[self alloc] init];
    label.attributedText = attributedText;
    return label;
}
+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:@"" font:font textColor:color alignment:NSTextAlignmentLeft numberOfLines:1];
}
+ (instancetype)labelWithFont:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)lines {
    return [self labelWithText:@"" font:font textColor:color alignment:alignment numberOfLines:lines];
}
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:text font:font textColor:color alignment:NSTextAlignmentLeft numberOfLines:1];
}
+ (instancetype)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)lines {
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
+ (instancetype)buttonWithTitle:(NSString *)title font:(nonnull UIFont *)font titleColor:(nonnull UIColor *)titleColor {
    return [self buttonWithTitle:title font:font titleColor:titleColor image:nil];
}
+ (instancetype)buttonWithTitle:(NSString *)title font:(nonnull UIFont *)font titleColor:(nonnull UIColor *)titleColor image:(UIImage * _Nullable)image {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitle:title font:font titleColor:titleColor];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}
+ (instancetype)buttonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector {
    return [self buttonWithImage:image selectedImage:nil target:target selector:selector];
}
+ (instancetype)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selected target:(id)target selector:(SEL)selector {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selected forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (instancetype)buttonWithBgImage:(UIImage *)image target:(id)target selector:(SEL)selector {
    return [self buttonWithBgImage:image selectedImage:nil target:target selector:selector];
}
+ (instancetype)buttonWithBgImage:(UIImage *)image selectedImage:(UIImage *)selected target:(id)target selector:(SEL)selector {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:selected forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (instancetype)buttonWithAttributedTitle:(NSAttributedString *)attributedTitle target:(id)target selector:(SEL)selector {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)setTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor {
    self.titleLabel.font = font;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
@end

@implementation UIColor (TTFactory)

+ (instancetype)tt_colorWithHexString:(NSString *)hex {
    return [UIColor colorWithHexString:hex];
}

@end
