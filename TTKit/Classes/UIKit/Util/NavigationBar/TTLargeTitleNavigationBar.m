//
//  TTLargeTitleNavigationBar.m
//  TTKit
//
//  Created by rollingstoneW on 2018/6/22.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTLargeTitleNavigationBar.h"
#import <objc/runtime.h>
#import "UIColor+YYAdd.h"
#import "UIView+YYAdd.h"
#import "Masonry.h"
#import "TTMacros.h"

@implementation UIButton (TTNavigationBarHiddenControl)
- (void)setHiddenWhenTitleHidden:(BOOL)hiddenWhenTitleHidden {
    objc_setAssociatedObject(self, @selector(hiddenWhenTitleHidden), @(hiddenWhenTitleHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)hiddenWhenTitleHidden {
    NSNumber *hidden = objc_getAssociatedObject(self, @selector(hiddenWhenTitleHidden));
    return hidden ? hidden.boolValue : YES;
}
@end

@interface TTLargeTitleNavigationBar ()

@property (nonatomic, strong) UILabel *largeTitleLabel;
@property (nonatomic, strong) UIView *supplementView;

@property (nonatomic, assign) BOOL shouldUpdatePercent;

@end

@implementation TTLargeTitleNavigationBar

#pragma mark - Init

+ (void)initialize {
    if (self == [TTLargeTitleNavigationBar class]) {
        TTLargeTitleNavigationBar *appearance = [TTLargeTitleNavigationBar appearance];
        [appearance setLargeTitleAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:28],
                                              NSForegroundColorAttributeName:UIColorHex(333333)}];
        [appearance setSupplementInsets:UIEdgeInsetsMake(0, 16, 16, 16)];
        [appearance setSupplementHeight:48];
    }
}

- (void)initializer {
    [super initializer];

    self.showingPercent = 1;

    self.supplementView = [UIView new];
    self.supplementView.backgroundColor = [UIColor whiteColor];

    self.largeTitleLabel = [UILabel new];

    [self addSubview:self.supplementView];
    [self sendSubviewToBack:self.supplementView];
    [self.supplementView addSubview:self.largeTitleLabel];
    
    self.backButton.hiddenWhenTitleHidden = NO;
}

#pragma mark - Public Methods

- (void)handleScrollViewContentOffsetY:(CGFloat)contentOffsetY {
    self.ignoreCurrentUpdateConstraints = YES;
    if (contentOffsetY > self.toStartShowContentOffsetY + self.supplementHeight) {
        self.showingPercent = 0;
    } else if (contentOffsetY > self.toStartShowContentOffsetY) {
        self.showingPercent = 1 - (contentOffsetY - self.toStartShowContentOffsetY) / self.supplementHeight;
    } else {
        self.showingPercent = 1;
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.supplementView.translatesAutoresizingMaskIntoConstraints) {
        [self.supplementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
        }];
    }
    if (self.supplementRightView.translatesAutoresizingMaskIntoConstraints) {
        [self.supplementRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(self.supplementView);
            make.left.greaterThanOrEqualTo(self.largeTitleLabel.mas_right).offset(20);
        }];
    }

    [self.largeTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.supplementView).offset([self largeTitleLabelPaddingBottom] - self.supplementInsets.bottom);
        make.left.equalTo(self.supplementView).offset(self.supplementInsets.left);
        if (!self.supplementRightView) {
            make.right.equalTo(self.supplementView).offset(-self.supplementInsets.right);
        }
    }];
    [self.supplementView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.supplementHeight));
    }];
    [self.supplementRightView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.supplementView).insets(self.supplementInsets);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.shouldUpdatePercent && !CGRectIsEmpty(self.bounds)) {
        self.shouldUpdatePercent = NO;
        [self updatePercent];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kScreenWidth, [[TTNavigationBar class] barHeight] + self.supplementHeight * self.showingPercent);
}

#pragma mark - Private Methods

- (void)updatePercent {
    [self invalidateIntrinsicContentSize];
    self.height = [self intrinsicContentSize].height;

    CGFloat largeViewVisibleHeight = self.supplementHeight * self.showingPercent;
    BOOL shouldTitleHidden = largeViewVisibleHeight > [self largeTitleLabelPaddingBottom];

    if (shouldTitleHidden != self.titleView.hidden) {
        NSArray *allBarButtonItems = [self.leftButtons arrayByAddingObjectsFromArray:self.rightButtons];
        for (UIButton *button in allBarButtonItems) {
            if (button.hiddenWhenTitleHidden) {
                button.hidden = shouldTitleHidden;
            }
        }

        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        [self.titleView.layer addAnimation:transition forKey:@"fade"];
    }

    self.titleView.hidden = shouldTitleHidden;
    _largeTitleHidden = !self.titleView.hidden;
}

- (CGFloat)largeTitleLabelPaddingBottom {
    UIFont *font = [self.largeTitleAttributes objectForKey:NSFontAttributeName];
    return font.pointSize * 0.1;
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    [super setTitle:title];

    if (title.length) {
        self.largeTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.largeTitleAttributes];
    }
}

- (void)setLargeTitleAttributes:(NSDictionary *)largeTitleAttributes {
    _largeTitleAttributes = largeTitleAttributes;
    if (!self.title) {
        return;
    }
    self.largeTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:self.largeTitleAttributes];
}

- (void)setSupplementInsets:(UIEdgeInsets)supplementInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(_supplementInsets, supplementInsets)) {
        return;
    }
    _supplementInsets = supplementInsets;
    [self setNeedsUpdateConstraints];
}

- (void)setSupplementRightView:(UIView *)supplementRightView {
    [_supplementRightView removeFromSuperview];
    if (supplementRightView) {
        [self.supplementView addSubview:supplementRightView];
    }
    _supplementRightView = supplementRightView;
    supplementRightView.translatesAutoresizingMaskIntoConstraints = YES;
    [self setNeedsUpdateConstraints];
}

- (void)setLargeTitleHidden:(BOOL)largeTitleHidden {
    [self setLargeTitleHidden:largeTitleHidden animated:NO layoutSuperview:NO];
}

- (void)setLargeTitleHidden:(BOOL)largeTitleHidden animated:(BOOL)animated layoutSuperview:(BOOL)layoutSuperview{
    kSetterCondition(largeTitleHidden)
    self.showingPercent = largeTitleHidden ? 0 : 1;

    !animated ?:  [UIView animateWithDuration:.25 animations:^{
        [(layoutSuperview ? self.superview : self) layoutIfNeeded];
    }];
}

- (void)setShowingPercent:(CGFloat)showingPercent {
    kSetterCondition(showingPercent)

    if (CGRectIsEmpty(self.bounds)) {
        self.shouldUpdatePercent = YES;
        return;
    }
    [self updatePercent];
}

- (void)setSupplementHeight:(CGFloat)supplementHeight {
    kSetterCondition(supplementHeight);
    [self setNeedsUpdateConstraints];
    [self updatePercent];
}

@end

