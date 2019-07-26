//
//  TTNavigationBar.m
//  TTKit
//
//  Created by rollingstoneW on 2018/9/17.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTNavigationBar.h"
#import "Masonry.h"
#import "UIColor+YYAdd.h"
#import <objc/runtime.h>
#import "TTMacros.h"
#import "UIButton+TTTouchArea.h"
#import "UIView+TTUtil.h"

@interface TTNavigationBar ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *titleContainer;
@property (nonatomic, strong) UIView *leftButtonContainer;
@property (nonatomic, strong) UIView *rightButtonContainer;

@property (nonatomic, strong) UIView *shadowLine;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSMutableArray<UIButton *> *innerLeftButtons;
@property (nonatomic, strong) NSMutableArray<UIButton *> *innerRightButtons;

@property (nonatomic, strong) MASConstraint *titleCenterX;
@property (nonatomic, strong) MASConstraint *titleLeftEqual;
@property (nonatomic, strong) MASConstraint *titleLeftGreatThanOrEqual;

@end

@implementation TTNavigationBar
@synthesize leftButtons = _leftButtons;
@synthesize rightButtons = _rightButtons;
@synthesize titleView = _titleView;

#pragma mark - Init

+ (void)initialize {
    if (self == [TTNavigationBar class]) {
        TTNavigationBar *appearance = [TTNavigationBar appearance];
        [appearance setTitleAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17],
                                         NSForegroundColorAttributeName : UIColorHex(333333)}];
        [appearance setItemSpace:10];
        [appearance setHoriIndent:15];
        [appearance setBackImage:[UIImage imageNamed:@"nav_bar_back"]];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    self.innerLeftButtons = [NSMutableArray array];
    self.innerRightButtons = [NSMutableArray array];

    [self addSubview:self.backgroundView];
    [self addSubview:self.shadowLine];
    [self.backgroundView addSubview:self.titleContainer];
    [self.backgroundView addSubview:self.leftButtonContainer];
    [self.backgroundView addSubview:self.rightButtonContainer];
    [self.titleContainer addSubview:self.titleLabel];

    self.showBackButton = YES;
    [self tt_setContentHorizentalResistancePriority:UILayoutPriorityDefaultHigh];
    [self tt_setContentVerticalResistancePriority:UILayoutPriorityDefaultHigh];
}

- (void)didMoveToSuperview {
    if (self.superview) {
        [self sizeToFit];
    }
}

#pragma mark - Public Methods

- (void)addLeftButton:(UIButton *)item {
    NSAssert(item && [item isKindOfClass:[UIButton class]], @"item must be a button");
    if (!item) return;

    UIButton *lastItem = self.innerLeftButtons.lastObject;
    [[self masBorderInButton:lastItem] uninstall];

    [self.leftButtonContainer addSubview:item];
    [self.innerLeftButtons addObject:item];

    BOOL isItemLast = !_leftButtons.count || item == _leftButtons.lastObject;

    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftButtonContainer);
        if (lastItem) {
            make.left.equalTo(lastItem.mas_right).offset(self.itemSpace);
        } else {
            make.left.equalTo(self.leftButtonContainer).offset(self.horiIndent);
        }
        if (isItemLast) {
            [self setMasBorder:make.right.equalTo(self.leftButtonContainer).offset(-self.itemSpace) inButton:item];
        }
        if (item == self.backButton) {
            make.width.greaterThanOrEqualTo(@20);
        }
    }];

    if (self.innerLeftButtons.count > 1) {
        item.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.itemSpace / 2, 0, -self.itemSpace / 2);
    } else {
        item.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.horiIndent, 0, -self.itemSpace / 2);
    }
}

- (void)addRightButton:(UIButton *)item {
    NSAssert(item && [item isKindOfClass:[UIButton class]], @"item must be a button");
    if (!item) return;

    UIButton *lastItem = self.innerRightButtons.lastObject;
    [[self masBorderInButton:lastItem] uninstall];

    [self.rightButtonContainer addSubview:item];
    [self.innerRightButtons addObject:item];

    BOOL isItemLast = !_rightButtons.count || item == _rightButtons.lastObject;

    [item mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightButtonContainer);
        if (lastItem) {
            make.right.equalTo(lastItem.mas_left).offset(-self.itemSpace).key(@"1");
        } else {
            make.right.equalTo(self.rightButtonContainer).offset(-self.horiIndent);
        }
        if (isItemLast) {
            [self setMasBorder:make.left.equalTo(self.rightButtonContainer).offset(self.itemSpace) inButton:item];
        }
    }];

    if (self.innerRightButtons.count > 1) {
        item.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.itemSpace / 2, 0, -self.itemSpace / 2);
    } else {
        item.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.itemSpace / 2, 0, -self.horiIndent);
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.ignoreCurrentUpdateConstraints) {
        self.ignoreCurrentUpdateConstraints = NO;
        return;
    }

    if (self.backgroundView.translatesAutoresizingMaskIntoConstraints) {
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@([TTNavigationBar barHeight]));
        }];
        [self.leftButtonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView).offset([TTNavigationBar statusBarHeight]);
            make.left.bottom.equalTo(self.backgroundView);
        }];
        [self.rightButtonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView).offset([TTNavigationBar statusBarHeight]);
            make.right.bottom.equalTo(self.backgroundView);
        }];
        [self.titleContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundView).offset([TTNavigationBar statusBarHeight]);
            self.titleCenterX = make.centerX.equalTo(self);
            make.bottom.equalTo(self.backgroundView);
            make.width.greaterThanOrEqualTo(@60);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.titleContainer);
        }];
        [self.shadowLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(1/[UIScreen mainScreen].scale));
        }];
        [self layoutTitleContainer];
    }
    [self makeTitleLeftEqualConstraint];
    [self.titleContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(@(kScreenWidth - self.horiIndent * 2));
    }];
    [self.leftButtonContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        self.titleLeftGreatThanOrEqual = make.right.lessThanOrEqualTo(self.titleContainer.mas_left).offset(-self.itemSpace);
    }];
    [self.rightButtonContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.titleContainer.mas_right).offset(self.itemSpace);
    }];

    [self updateBarButtonItemConstraints];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kScreenWidth, [TTNavigationBar barHeight]);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

+ (CGFloat)statusBarHeight {
    return kStatusBarHeight;
}

+ (CGFloat)barHeight {
    return [self statusBarHeight] + 44;
}

#pragma mark - Private Methods

static const void *masBorderKey = &masBorderKey;
- (MASConstraint *)masBorderInButton:(UIButton *)button {
    return objc_getAssociatedObject(button, masBorderKey);
}

- (void)setMasBorder:(MASConstraint *)border inButton:(UIButton *)button {
    objc_setAssociatedObject(button, masBorderKey, border, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)updateBarButtonItemConstraints {
    for (NSInteger i = 0; i < self.innerLeftButtons.count; i++) {
        UIButton *button = self.innerLeftButtons[i];
        if (i == 0) {
            button.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.horiIndent, 0, -self.itemSpace / 2);;
        } else {
            button.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.itemSpace / 2, 0, -self.itemSpace / 2);
        }
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.leftButtonContainer).offset(self.horiIndent);
            } else if (i > 0) {
                UIButton *lastButton = self.innerLeftButtons[i-1];
                make.left.equalTo(lastButton.mas_right).offset(self.itemSpace);
            }
            if (i == self.innerLeftButtons.count - 1) {
                make.right.equalTo(self.leftButtonContainer).offset(-self.itemSpace);
            }
        }];
    }
    for (NSInteger i = 0; i < self.innerRightButtons.count; i++) {
        UIButton *button = self.innerRightButtons[i];
        if (i == 0) {
            button.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.itemSpace / 2, 0, -self.horiIndent);
        } else {
            button.tt_hitTestEdgeInsets = UIEdgeInsetsMake(0, -self.itemSpace / 2, 0, -self.itemSpace / 2);
        }
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.right.equalTo(self.rightButtonContainer).offset(-self.horiIndent);
            } else if (i > 0) {
                UIButton *lastButton = self.innerRightButtons[i-1];
                make.right.equalTo(lastButton.mas_left).offset(-self.itemSpace);
            }
            if (i == self.innerRightButtons.count - 1) {
                make.left.equalTo(self.rightButtonContainer).offset(self.itemSpace);
            }
        }];
    }
}

- (void)layoutTitleContainer {
    if (self.titleAlignment == TTNavigationBarTitleAlignmentCenter) {
        [self.titleCenterX install];
        [self.titleLeftGreatThanOrEqual install];
        [self.titleLeftEqual uninstall];
    } else if (self.titleAlignment == TTNavigationBarTitleAlignmentAfterLeftButtons) {
        [self.titleCenterX uninstall];
        [self.titleLeftGreatThanOrEqual uninstall];
        if (!self.titleLeftEqual) {
            [self makeTitleLeftEqualConstraint];
        }
        [self.titleLeftEqual install];
    }
}

- (void)makeTitleLeftEqualConstraint {
    MASConstraintMaker *titleMaker = [[MASConstraintMaker alloc] initWithView:self.titleContainer];
    self.titleLeftEqual = titleMaker.left.equalTo(self.leftButtonContainer.mas_right).offset(self.itemSpace);
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) {
        return;
    }
    if (!title) {
        self.titleLabel.attributedText = nil;
        self.titleLabel.text = nil;
    } else {
        [self setAttributedText:[[NSAttributedString alloc] initWithString:title attributes:self.titleAttributes]];
    }
    _title = title;
}

- (void)setTitleAttributes:(NSDictionary *)titleAttributes {
    kSetterCondition(titleAttributes)
    if (!self.title) {
        return;
    }
    [self setAttributedText:[[NSAttributedString alloc] initWithString:self.title attributes:self.titleAttributes]];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.titleLabel.attributedText = attributedText;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@(MIN(attributedText.size.width, 40)));
    }];
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    _titleView = titleView;
    if (titleView) {
        self.titleLabel.hidden = YES;
        [self.titleContainer addSubview:titleView];
    } else {
        self.titleLabel.hidden = NO;
    }
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleContainer);
    }];
}

- (void)setTitleAlignment:(TTNavigationBarTitleAlignment)titleAlignment {
    kSetterCondition(titleAlignment)
    [self layoutTitleContainer];
}

- (void)setBackImage:(UIImage *)backImage {
    kSetterCondition(backImage);
    [self.backButton setImage:backImage forState:UIControlStateNormal];
}

- (void)setBackHighlightedImage:(UIImage *)backHighlightedImage {
    kSetterCondition(backHighlightedImage);
    [self.backButton setBackgroundImage:backHighlightedImage forState:UIControlStateHighlighted];
}

- (void)setShowBackButton:(BOOL)showBackButton {
    kSetterCondition(showBackButton);
    if (showBackButton) {
        [self.innerLeftButtons insertObject:self.backButton atIndex:0];
    } else {
        [self.innerLeftButtons removeObject:self.backButton];
    }
    [self setLeftButtons:self.innerLeftButtons.copy];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    kSetterCondition(backgroundImage);
    self.backgroundView.layer.contents = (__bridge id _Nullable)(backgroundImage.CGImage);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundView.backgroundColor = backgroundColor;
}

- (void)setHoriIndent:(CGFloat)horiIndent {
    kSetterCondition(horiIndent)
    [self setNeedsUpdateConstraints];
}

- (void)setItemSpace:(CGFloat)itemSpace {
    kSetterCondition(itemSpace)
    [self setNeedsUpdateConstraints];
}

- (void)setLeftButtons:(NSArray<UIButton *> *)leftButtons {
    [self.leftButtonContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.innerLeftButtons removeAllObjects];
    _leftButtons = leftButtons;
    for (UIButton *button in leftButtons) {
        [self addLeftButton:button];
    }
    _leftButtons = nil;
}

- (void)setRightButtons:(NSArray<UIButton *> *)rightButtons {
    [self.rightButtonContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.innerRightButtons removeAllObjects];
    _rightButtons = rightButtons;
    for (UIButton *button in rightButtons) {
        [self addRightButton:button];
    }
    _rightButtons = nil;
}

#pragma mark - Getters

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.layer.contentsGravity = kCAGravityResizeAspectFill;
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UIView *)titleContainer {
    if (!_titleContainer) {
        _titleContainer = [[UIView alloc] init];
    }
    return _titleContainer;
}

- (UIView *)leftButtonContainer {
    if (!_leftButtonContainer) {
        _leftButtonContainer = [[UIView alloc] init];
        _leftButtonContainer.clipsToBounds = YES;
    }
    return _leftButtonContainer;
}

- (UIView *)rightButtonContainer {
    if (!_rightButtonContainer) {
        _rightButtonContainer = [[UIView alloc] init];
        _rightButtonContainer.clipsToBounds = YES;
        [_rightButtonContainer setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                               forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _rightButtonContainer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UIView *)titleView {
    return _titleView ?: self.titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _backButton;
}

- (UIView *)shadowLine {
    if (!_shadowLine) {
        _shadowLine = [[UIView alloc] init];
        _shadowLine.backgroundColor = UIColorHex(e5e5e5);
    }
    return _shadowLine;
}

- (NSArray<UIButton *> *)leftButtons {
    return self.innerLeftButtons.copy;
}

- (NSArray<UIButton *> *)rightButtons {
    return self.innerRightButtons.copy;
}

@end
