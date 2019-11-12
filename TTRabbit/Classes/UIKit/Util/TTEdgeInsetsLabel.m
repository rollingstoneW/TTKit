//
//  TTKitEdgeInsetLabel.m
//  TTKit
//
//  Created by rollingstoneW on 2018/7/25.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTEdgeInsetsLabel.h"

@implementation TTEdgeInsetsLabel

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

@end
