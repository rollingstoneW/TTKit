//
//  UILabel+TTUtil.m
//  TTRabbit
//
//  Created by ZYB on 2020/2/26.
//

#import "UILabel+TTUtil.h"

@implementation UILabel (TTUtil)

- (void)tt_setLineSpacing:(CGFloat)lineSpacing {
    if (self.attributedText) {
        NSMutableParagraphStyle *ps = [[self.attributedText attributesAtIndex:0 effectiveRange:nil] valueForKey:NSParagraphStyleAttributeName];
        ps = ps ? ps.mutableCopy : [[NSMutableParagraphStyle alloc] init];
        ps.lineSpacing = lineSpacing;
        ps.alignment = self.textAlignment;
        NSMutableAttributedString *newText = self.attributedText.mutableCopy;
        [newText addAttributes:@{NSParagraphStyleAttributeName: ps} range:NSMakeRange(0, self.text.length)];
        self.attributedText = newText;
    } else {
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineSpacing = lineSpacing;
        ps.alignment = self.textAlignment;
        NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] initWithString:self.text];
        [newText addAttributes:@{NSParagraphStyleAttributeName: ps} range:NSMakeRange(0, self.text.length)];
        self.attributedText = newText;
    }
}

@end
