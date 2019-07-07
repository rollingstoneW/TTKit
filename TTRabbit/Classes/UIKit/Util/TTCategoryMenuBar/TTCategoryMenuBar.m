//
//  TTCategoryMenuBar.m
//  TTKit
//
//  Created by rollingstoneW on 2019/7/1.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTCategoryMenuBar.h"
#import "TTCategoryMenuBarUtil.h"
#import "TTCategoryMenuBarOptionView.h"
#import "Masonry.h"

@interface  TTCategoryMenuBarBackgroundView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) dispatch_block_t tapedBlock;
@end

@implementation TTCategoryMenuBarBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedAction)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapedAction {
    !self.tapedBlock ?: self.tapedBlock();
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (CGRectContainsPoint(self.subviews.firstObject.frame, [gestureRecognizer locationInView:self])) {
        return NO;
    }
    return YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.alpha < 00.1 || self.hidden) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

@end

@interface TTCategoryMenuBar () <TTCategoryMenuBarOptionViewDelegate>

@property (nonatomic, strong) UIView *barItemContainerView;
@property (nonatomic, strong) TTCategoryMenuBarBackgroundView *backgroundView;
@property (nonatomic, strong) UIView *optionContainerView;

@property (nonatomic,   weak) TTCategoryMenuBarOptionView *currentOptionView;
@property (nonatomic, assign) UIButton *currentItem;

@end

@implementation TTCategoryMenuBar

- (instancetype)initWithItems:(NSArray<TTCategoryMenuBarCategoryItem *> *)items
                      options:(NSArray<NSArray<TTCategoryMenuBarOptionItem *> *> *)options {
    if (self = [super initWithFrame:CGRectZero]) {
        _items = items;
        _options = options;
        
        self.barItemContainerView = [[UIView alloc] init];
        self.barItemContainerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.barItemContainerView];
        [self.barItemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = TTCategoryMenuBarLineColor();
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@(TTCategoryMenuBar1PX));
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 已经布局完成
    if (!CGSizeEqualToSize(self.frame.size, CGSizeZero) && !self.barItemContainerView.subviews.count) {
        [self reloadItems];
    }
}

- (void)reloadItems:(NSArray<__kindof TTCategoryMenuBarCategoryItem *> *)items options:(NSArray<NSArray<__kindof TTCategoryMenuBarOptionItem *> *> *)options {
    self.items = items;
    self.options = options;
    [self reloadItems];
}

- (void)reloadItems {
    if (self.items.count != self.options.count) {
        NSAssert(NO, @"items数量要和options数量保持一致");
        return;
    }
    [self dismissOptionView:NO];
    [self.barItemContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIButton *lastButton;
    for (NSInteger i = 0; i < self.items.count; i++) {
        TTCategoryMenuBarCategoryItem *item = self.items[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(categoryClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *normal = item.attributedTitle ?: [[NSAttributedString alloc] initWithString:item.title ?: @""
                                                                                            attributes:item.titleAttributes];
        NSAttributedString *selected = item.selectedAttributedTitle ?:
        [[NSAttributedString alloc] initWithString:item.title ?: @"" attributes:item.selectedTitleAttributes];
        [button setAttributedTitle:normal forState:UIControlStateNormal];
        [button setAttributedTitle:selected forState:UIControlStateSelected];
        [button setAttributedTitle:selected forState:UIControlStateSelected | UIControlStateHighlighted];
        button.selected = item.isSelected;
        [self.barItemContainerView addSubview:button];
        if (item.icon) {
            [button setImage:item.icon forState:UIControlStateNormal];
            [button setImage:item.selectedIcon forState:UIControlStateSelected];
            [self layoutBarItem:button space:item.iconTitleSpace];
        }
        if (i != self.items.count - 1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = item.separatorLineColor;
            [button addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(button).inset(item.separatorLineIndent);
                make.right.equalTo(button);
                make.width.equalTo(@(1));
            }];
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastButton ? lastButton.mas_right : self.barItemContainerView);
            make.top.bottom.equalTo(self.barItemContainerView);
            if (lastButton) {
                make.width.equalTo(lastButton);
            }
            if (i == self.items.count - 1) {
                make.right.equalTo(self.barItemContainerView);
            }
        }];
        if ([self.delegate respondsToSelector:@selector(categoryMenuBar:configButtonItem:atCategory:)]) {
            [self.delegate categoryMenuBar:self configButtonItem:button atCategory:i];
        }
        lastButton = button;
    }
}

- (void)categoryClicked:(UIButton *)button {
    TTCategoryMenuBarCategoryItem *item = self.items[button.tag];
    BOOL isDimming = self.backgroundView.alpha == 1;
    BOOL isButtonSelected = button.isSelected;
    UIButton *currentItem = self.currentItem;
    [self dismissOptionView:(button == self.currentItem || item.style == TTCategoryMenuBarCategoryStyleNoneData)];

    if (item.style == TTCategoryMenuBarCategoryStyleNoneData) {
        if (button.isSelected) {
            button.selected = item.isSelected = NO;
            self.currentItem = nil;
        } else {
            button.selected = item.isSelected = YES;
            self.currentItem = button;
            if ([self.delegate respondsToSelector:@selector(categoryMenuBar:didSelectCategory:)]) {
                [self.delegate categoryMenuBar:self didSelectCategory:button.tag];
            }
        }
    } else {
        if (button != currentItem || !isButtonSelected) {
            button.selected = item.isSelected = YES;
            self.currentItem = button;
            if ([self.delegate respondsToSelector:@selector(categoryMenuBar:didSelectCategory:)]) {
                [self.delegate categoryMenuBar:self didSelectCategory:button.tag];
            }
            if (item.style != TTCategoryMenuBarCategoryStyleNoneData) {
                // 如果之前有蒙层，接着使用之前的蒙层，避免突兀
                self.backgroundView.alpha = isDimming;
                [self showOptionView];
            }
        }
    }
}

- (void)showOptionView {
    TTCategoryMenuBarCategoryItem *item = self.items[self.currentItem.tag];
    TTCategoryMenuBarOptionView *optionView;
    switch (item.style) {
        case TTCategoryMenuBarCategoryStyleSingleList:
            optionView = [[TTCategoryMenuBarSingleListOptionView alloc] initWithCategory:item options:self.options[self.currentItem.tag]];
            break;
        case TTCategoryMenuBarCategoryStyleDoubleList:
            optionView = [[TTCategoryMenuBarDoubleListOptionView alloc] initWithCategory:item options:self.options[self.currentItem.tag]];
            break;
        case TTCategoryMenuBarCategoryStyleTripleList:
            optionView = [[TTCategoryMenuBarTripleListOptionView alloc] initWithCategory:item options:self.options[self.currentItem.tag]];
            break;
        case TTCategoryMenuBarCategoryStyleSectionList:
            optionView = [[TTCategoryMenuBarSectionListView alloc] initWithCategory:item options:self.options[self.currentItem.tag]];
            break;
        case TTCategoryMenuBarCategoryStyleCustom:
            if ([self.delegate respondsToSelector:@selector(categoryMenuBar:optionViewAtIndex:)]) {
                optionView = [self.delegate categoryMenuBar:self optionViewAtIndex:self.currentItem.tag];
            }
            break;
        default:
            break;
    }
    if (optionView) {
        [self loadBackgroundViewIfNeeded];
        self.currentOptionView = optionView;
        optionView.delegate = self;
        [self insertSubview:self.backgroundView belowSubview:self.barItemContainerView];
        [self.backgroundView addSubview:optionView];

        [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.barItemContainerView.mas_bottom);
            make.left.right.equalTo(self);
        }];
        [self layoutIfNeeded];
        if ([self.delegate respondsToSelector:@selector(categoryMenuBar:willShowOptionView:atCategory:)]) {
            [self.delegate categoryMenuBar:self willShowOptionView:optionView atCategory:self.currentItem.tag];
        }
        
        [optionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.barItemContainerView.mas_bottom).offset(0);
            make.left.right.equalTo(self);
        }];
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:.25 animations:^{
            [self rotateItemIcon:self.currentItem];
            self.backgroundView.alpha = 1;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }
}

- (void)dismissOptionView:(BOOL)animated {
    if (!self.currentOptionView) {
        return;
    }
    self.currentItem.selected = self.currentOptionView.categoryItem.isSelected = self.currentOptionView.selectedOptions.count > 0 || self.currentOptionView.categoryItem.style == TTCategoryMenuBarCategoryStyleNoneData;
    [self.currentOptionView clearSelectedOptions];
    [self.currentOptionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.barItemContainerView.mas_bottom).offset(-self.currentOptionView.frame.size.height);
    }];
    if (animated) {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:.25 animations:^{
            self.backgroundView.alpha = 0;
            [self layoutIfNeeded];
            [self resetItemIcon:self.currentItem];
        } completion:^(BOOL finished) {
            self.currentItem = nil;
            self.userInteractionEnabled = YES;
            [self.currentOptionView removeFromSuperview];
        }];
    } else {
        [self resetItemIcon:self.currentItem];
        [self.currentOptionView removeFromSuperview];
        self.backgroundView.alpha = 0;
        self.currentItem = nil;
    }
}

- (UIButton *)menuButtonItemAtCategory:(NSInteger)category {
    return [self.barItemContainerView viewWithTag:category];
}

- (void)resetItemIcon:(UIButton *)button {
    if (self.items[button.tag].shouldIconAutoRotate) {
        button.imageView.transform = CGAffineTransformIdentity;
    }
}

- (void)rotateItemIcon:(UIButton *)button {
    if (self.items[button.tag].shouldIconAutoRotate) {
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)categoryBarOptionViewDidResetOptions:(__kindof TTCategoryMenuBarOptionView *)categoryBarOptionView {
    if ([self.delegate respondsToSelector:@selector(categoryMenuBar:didResetCategory:)]) {
        [self.delegate categoryMenuBar:self didResetCategory:self.currentItem.tag];
    }
}

- (void)categoryBarOptionView:(__kindof TTCategoryMenuBarOptionView *)categoryBarOptionView
             didCommitOptions:(NSArray<TTCategoryMenuBarOptionItem *> *)options {
    if ([self.delegate respondsToSelector:@selector(categoryMenuBar:didCommitCategoryOptions:atCategory:)]) {
        [self.delegate categoryMenuBar:self didCommitCategoryOptions:options atCategory:self.currentItem.tag];
    }
    [self dismissOptionView:YES];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self.barItemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(contentInset);
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_backgroundView.alpha) {
        if (CGRectContainsPoint(self.backgroundView.frame, point)) {
            return YES;
        }
    }
    return [super pointInside:point withEvent:event];
}

- (void)layoutBarItem:(UIButton *)button space:(CGFloat)space {
    CGSize imageSize = button.imageView.image.size;
    CGSize titleSize;
    if (button.titleLabel.attributedText) {
        titleSize = [button.titleLabel.attributedText size];
    } else {
        titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    }

    CGFloat insetAmount = ABS(space / 2.0);
    if (space > 0) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
    } else {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + insetAmount), 0, imageSize.width + insetAmount);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + insetAmount, 0, -(titleSize.width + insetAmount));
        button.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
    }
}

- (void)loadBackgroundViewIfNeeded {
    if (!self.backgroundView && self.superview) {
        self.backgroundView = [[TTCategoryMenuBarBackgroundView alloc] init];
        self.backgroundView.alpha = 0;
        __weak __typeof(self) weakSelf = self;
        self.backgroundView.tapedBlock = ^{
            [weakSelf dismissOptionView:YES];
        };
        [self addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.superview);
        }];
    }
}

- (UIView *)optionContainerView {
    if (!_optionContainerView) {
        _optionContainerView = [[UIView alloc] init];
    }
    return _optionContainerView;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(TTCategoryMenuBarScreenWidth, TTCategoryMenuBarHeight);
}

@end
