//
//  TTKitEdgeInsetLabel.m
//  TTKit
//
//  Created by rollingstoneW on 2018/7/25.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTEdgeInsetsLabel.h"

@implementation TTEdgeInsetsLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];

    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;

    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize nSize = [super sizeThatFits:size];

    nSize.width  += self.edgeInsets.left + self.edgeInsets.right;
    nSize.height += self.edgeInsets.top + self.edgeInsets.bottom;

    return nSize;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectIntegral(frame)];
}

- (void)setText:(NSString *)text {
    [super setText:text];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
