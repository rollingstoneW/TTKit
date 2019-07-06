//
//  UIButton+TTImagePosition.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UIButton+TTImagePosition.h"
#import <objc/runtime.h>

@interface UIButton (TTPrivate)

@property (nonatomic, assign) UIEdgeInsets tt_lastContentInsets;;
@property (nonatomic, assign) UIEdgeInsets tt_lastAdjustedContentInsets;

@end

@implementation UIButton (TTImagePosition)

+ (instancetype)tt_iconWithImage:(UIImage *)image
                            text:(NSString *)text
                   imagePosition:(TTButtonImagePosition)imagePosition
                           space:(CGFloat)space {
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button tt_layoutWithImagePosition:imagePosition space:space];
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.enabled = NO;
    return button;
}

- (void)tt_layoutWithImagePosition:(TTButtonImagePosition)style space:(CGFloat)space {
    if (!UIEdgeInsetsEqualToEdgeInsets(self.contentEdgeInsets, self.tt_lastAdjustedContentInsets)) {
        self.tt_lastContentInsets = self.contentEdgeInsets;
    }

    CGSize imageSize = self.imageView.image.size;
    CGSize titleSize;
    if (self.titleLabel.attributedText) {
        titleSize = [self.titleLabel.attributedText size];
    } else {
        titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    }

    CGFloat cL = self.tt_lastContentInsets.left;
    CGFloat cT = self.tt_lastContentInsets.top;
    CGFloat cR = self.tt_lastContentInsets.right;
    CGFloat cB = self.tt_lastContentInsets.bottom;

    CGFloat insetAmount = space / 2.0;
    CGFloat insetHorizental = (MAX(titleSize.width, imageSize.width) - (titleSize.width + imageSize.width)) / 2;
    CGFloat insetVertical = (MIN(titleSize.height, imageSize.height) + space) / 2;

    switch (style)
    {
        case TTButtonImagePositionLeft : {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
            self.contentEdgeInsets = UIEdgeInsetsMake(0 + cT, insetAmount + cL, 0 + cB, insetAmount + cR);
        }
            break;
        case TTButtonImagePositionRight : {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + insetAmount), 0, imageSize.width + insetAmount);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + insetAmount, 0, -(titleSize.width + insetAmount));
            self.contentEdgeInsets = UIEdgeInsetsMake(0 + cT, insetAmount + cL, 0 + cB, insetAmount + cR);
        }
            break;
        case TTButtonImagePositionTop : {
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + space), 0.0);
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + space), 0.0, 0.0, -titleSize.width);
            self.contentEdgeInsets = UIEdgeInsetsMake(insetVertical + cT, insetHorizental + cL, insetVertical + cB, insetHorizental + cR);
        }
            break;
        case TTButtonImagePositionBottom : {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageSize.height + space), -imageSize.width, 0, 0.0);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0.0, -(titleSize.height + space), -titleSize.width);
            self.contentEdgeInsets = UIEdgeInsetsMake(insetVertical + cT, insetHorizental + cL, insetVertical + cB, insetHorizental + cR);
        }
    }
    self.tt_lastAdjustedContentInsets = self.contentEdgeInsets;
}

- (void)tt_resetEdgeInsets {
    self.imageEdgeInsets = self.titleEdgeInsets = UIEdgeInsetsZero;
    self.contentEdgeInsets = self.tt_lastContentInsets;
    self.tt_lastContentInsets = self.tt_lastAdjustedContentInsets = UIEdgeInsetsZero;
}

- (UIEdgeInsets)tt_lastContentInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}
- (void)setTt_lastContentInsets:(UIEdgeInsets)tt_lastContentInsets {
    objc_setAssociatedObject(self, @selector(tt_lastContentInsets), [NSValue valueWithUIEdgeInsets:tt_lastContentInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tt_lastAdjustedContentInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}
- (void)setTt_lastAdjustedContentInsets:(UIEdgeInsets)tt_lastAdjustedContentInsets {
    objc_setAssociatedObject(self, @selector(tt_lastAdjustedContentInsets), [NSValue valueWithUIEdgeInsets:tt_lastAdjustedContentInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
