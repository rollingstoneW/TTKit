//
//  TTMultiSelectionAlertView.m
//  TTKit
//
//  Created by rollingstoneW on 2018/9/3.
//  Copyright © 2018年 TTKit. All rights reserved.
//

#import "TTMultiSelectionAlertView.h"
#import "UIColor+YYAdd.h"
#import "Masonry.h"
#import "TTMacros.h"

static const NSInteger ButtonTag = 10000;
static const CGFloat containerLeft = 36;

@interface TTMultiSelectionAlertView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *assureButton;
@property (nonatomic, strong) UIView *buttonContainer;

@property (nonatomic, strong) NSMutableArray *selectionButtons;
@property (nonatomic, strong) NSMutableArray *titleButtons;

@property (nonatomic, strong) NSArray *selections;
@property (nonatomic,   copy) NSString *title;
@property (nonatomic, assign) BOOL ishide;


@end

@implementation TTMultiSelectionAlertView

- (instancetype)initWithSelections:(NSArray *)selections title:(NSString *)title hideButton:(BOOL)hide{
    if (self = [super init]) {
        self.selections = selections;
        self.title = title;
        self.ishide = hide;
        self.allowsMultipleSelection = YES;
        [self loadSubviews];
    }
    return self;
}

- (void)showInAppDelegateWindow {
    [self showAddedAlertViewTo:[[UIApplication sharedApplication].delegate window] animated:YES];
}

- (void)showAddedAlertViewTo:(UIView *)view animated:(BOOL)animated {
    [view addSubview:self];
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (animated) {
        [UIView animateWithDuration:.25 animations:^{
            self.alpha = 1;
        }];
    } else {
        self.alpha = 1;
    }
}

- (void)dismiss {
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.didDisappearBlock) {
            self.didDisappearBlock();
        }
    }];

}

- (void)assureAction {
    NSMutableArray *selections = [NSMutableArray array];
    NSMutableArray *indexes = [NSMutableArray array];
    [self.selectionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        [selections addObject:button.currentTitle];
        [indexes addObject:@(button.tag - ButtonTag)];
    }];
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(selections, indexes);
    }
    [self dismiss];
}

- (void)buttonClicked:(UIButton *)button {
    if ([self.selectionButtons containsObject:button]) {
        button.selected = NO;
    } else {
        if (self.allowsMultipleSelection) {
            button.selected = YES;
        } else {
            [self.selectionButtons.firstObject setSelected:NO];
            [self setupButtonSelection:self.selectionButtons.firstObject];
            button.selected = YES;
            [self.selectionButtons removeAllObjects];
        }
    }
    if (button.selected) {
        [self.selectionButtons addObject:button];
    } else {
        [self.selectionButtons removeObject:button];
    }

    [self setupButtonSelection:button];
}

- (void)setupButtonSelection:(UIButton *)button {
    if (button.selected) {
        button.layer.borderColor = button.layer.backgroundColor = UIColorHex(2290EA).CGColor;
    } else {
        button.layer.borderColor = UIColorHex(999999).CGColor;
        button.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
}

- (void)loadSubviews {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    self.alpha = 0;

    UIView *(^createLine)(void) = ^{
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorHex(edecec);
        return line;
    };
    UIView *topLine = createLine();
    UIView *bottomLine = createLine();
    UIView *buttonMiddleLine = createLine();

    self.titleLabel.text = self.title;

    [self addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:topLine];
    if (!self.ishide) {
        [self.containerView addSubview:bottomLine];
        [self.containerView addSubview:self.cancelButton];
        [self.containerView addSubview:self.assureButton];
        [self.containerView addSubview:buttonMiddleLine];
    } else {
        [self.containerView addSubview:self.closeButton];
    }

    [self loadSelectionButtons];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.right.equalTo(self).inset(containerLeft);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.equalTo(@45);
    }];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@(1.f/[UIScreen mainScreen].scale));
    }];
    if (!self.ishide) {
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cancelButton.mas_top);
            make.left.right.height.equalTo(topLine);
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(self.titleLabel.mas_bottom).offset(30);
            make.left.bottom.equalTo(self.containerView);
            make.height.equalTo(self.titleLabel);
        }];
        [buttonMiddleLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.cancelButton);
            make.width.equalTo(topLine.mas_height);
            make.left.equalTo(self.cancelButton.mas_right);
        }];
        [self.assureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.containerView);
            make.left.equalTo(self.cancelButton.mas_right);
            make.size.equalTo(self.cancelButton);
        }];
    } else {
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.containerView);
            make.height.width.equalTo(@45);
        }];
    }
}

- (void)loadSelectionButtons {
    CGFloat marginTop = 15;
    CGFloat marginLeft = 20;
    CGFloat space = 10;
    CGFloat currentButtonLeft = marginLeft;
    CGFloat currentButtonTop = marginTop;
    [self.titleButtons removeAllObjects];
    for (NSInteger i = 0; i < self.selections.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + ButtonTag;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1.f / [UIScreen mainScreen].scale;
        button.layer.borderColor = UIColorHex(999999).CGColor;
        button.layer.masksToBounds = YES;
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        [button setTitle:self.selections[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:UIColorHex(333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
        [self.titleButtons addObject:button];

        CGSize size = [button sizeThatFits:CGSizeMake(kScreenWidth, 100)];

        // 如果超出就换行
        if (size.width + currentButtonLeft + marginLeft > kScreenWidth - containerLeft * 2 ) {
            currentButtonTop += size.height + space;
            currentButtonLeft = marginLeft;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(currentButtonTop);
            make.left.equalTo(self.containerView).offset(currentButtonLeft);
            if (i == self.selections.count - 1) {
                if (self.ishide) {
                    make.bottom.equalTo(self.containerView).offset(-marginTop);
                } else {
                    make.bottom.equalTo(self.cancelButton.mas_top).offset(-marginTop);
                }
            }
        }];
        currentButtonLeft += size.width + space;
    }
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColorHex(333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorHex(333333) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"associated_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)assureButton {
    if (!_assureButton) {
        _assureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _assureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_assureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_assureButton setTitleColor:UIColorHex(2290EA) forState:UIControlStateNormal];
        [_assureButton addTarget:self action:@selector(assureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _assureButton;
}

- (NSMutableArray *)selectionButtons {
    if (!_selectionButtons) {
        _selectionButtons = [NSMutableArray array];
    }
    return _selectionButtons;
}

- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

@end
