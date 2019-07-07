//
//  TTCategoryMenuBarOptionView.m
//  TTKit
//
//  Created by rollingstoneW on 2019/7/1.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTCategoryMenuBarOptionView.h"
#import "TTCategoryMenuBarUtil.h"
#import "Masonry.h"

static NSString *const TTCategoryMenuBarCellID = @"cell";

@interface TTCategoryMenuBarCell : UITableViewCell
@property (nonatomic, strong) TTCategoryMenuBarListOptionItem *option;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UIView *separatorLine;
@end
@implementation TTCategoryMenuBarCell
@synthesize textLabel = _textLabel, imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = [[UIImageView alloc] init];

        [self addSubview:self.separatorLine];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.textLabel];
        [self.containerView addSubview:self.imageView];

        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(TTCategoryMenuBar1PX));
        }];
    }
    return self;
}

- (void)setOption:(TTCategoryMenuBarListOptionItem *)option {
    if (!_option ||
        (BOOL)option.icon != (BOOL)_option.icon ||
        (BOOL)option.selectedIcon != (BOOL)_option.selectedIcon ||
        option.iconTitleSpace != _option.iconTitleSpace) {

        if (option.icon && option.iconTitleSpace >= 0) {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.containerView);
                make.left.equalTo(self.containerView);
            }];
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.mas_right).offset(option.iconTitleSpace);
                make.right.top.bottom.equalTo(self.containerView);
            }];
        } else if (option.icon && option.iconTitleSpace < 0) {
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.containerView);
            }];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.right.equalTo(self.containerView);
                make.left.equalTo(self.textLabel.mas_right).offset(-option.iconTitleSpace);
                make.right.equalTo(self.containerView);
            }];
        } else {
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.containerView);
            }];
            [[MASViewConstraint installedConstraintsForView:self.imageView] makeObjectsPerformSelector:@selector(uninstall)];
        }
    }
    BOOL accessoryChanged = NO;
    if (!self.accessoryImageView && (option.accessoryIcon || option.selectedAccessoryIcon)) {
        accessoryChanged = YES;
        self.accessoryImageView = [[UIImageView alloc] init];
        [self.accessoryImageView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                                 forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:self.accessoryImageView];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-option.tailIndent);
        }];
    }
    self.accessoryImageView.image = option.accessoryIcon;
    self.accessoryImageView.highlightedImage = option.selectedAccessoryIcon ?: option.accessoryIcon;
    self.accessoryImageView.highlighted = option.isSelected;
    if (!_option || option.headIndent != _option.headIndent || option.tailIndent != _option.tailIndent || accessoryChanged) {
        if (!option.headIndent) {
            [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.centerX.equalTo(self);
                if (self.accessoryImageView) {
                    make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left).offset(-10);
                } else {
                    make.right.lessThanOrEqualTo(self).offset(-10);
                }
            }];
        } else {
            [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self).offset(option.headIndent);
                if (self.accessoryImageView) {
                    make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left).offset(-10);
                } else {
                    make.right.lessThanOrEqualTo(self).offset(-option.tailIndent);
                }
            }];
            [self.accessoryImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-option.tailIndent);
            }];
        }
    }
    if (!_option || option.separatorLineIndent != _option.separatorLineIndent) {
        [self.separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(option.separatorLineIndent);
        }];
    }
    
    _option = option;
    self.separatorLine.backgroundColor = option.separatorLineColor;
    self.backgroundColor = option.isSelected ? option.selectBackgroundColor : option.backgroundColor;
    if (option.isSelected || (option.isChildrenAllSelected && option.shouldSelectsTitleWhenChildrenAllSelected)) {
        self.imageView.image = option.selectedIcon ?: option.icon;
        self.textLabel.attributedText = [option.selectedAttributedTitle ?: [NSAttributedString alloc] initWithString:(option.title ?: @"")
                                                                                                          attributes:option.selectedTitleAttributes];
    } else {
        self.imageView.image = option.icon;
        self.textLabel.attributedText = [option.attributedTitle ?: [NSAttributedString alloc] initWithString:(option.title ?: @"")
                                                                                                  attributes:option.titleAttributes];
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _imageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
    }
    return _separatorLine;
}

@end

@interface TTCategoryMenuBarOptionView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *resetButton;

@property (nonatomic, strong) NSArray *selectedOptions;

@property (nonatomic, strong) TTCategoryMenuBarListCategoryItem *listCategoryItem;
@property (nonatomic, strong) TTCategoryMenuBarSectionCategoryItem *sectionCategoryItem;

@property (nonatomic, strong) NSArray<TTCategoryMenuBarListOptionItem *> *listOptions;
@property (nonatomic, strong) NSArray<TTCategoryMenuBarSectionItem *> *sectionOptions;

@property (nonatomic, assign) BOOL shouldInvalidateIntrnsicContentSize;

@end

@implementation TTCategoryMenuBarOptionView

- (instancetype)initWithCategory:(__kindof TTCategoryMenuBarCategoryItem *)category options:(NSArray<__kindof TTCategoryMenuBarOptionItem *> *)options {
    if (self = [super init]) {
        _categoryItem = category;
        if ([category isKindOfClass:[TTCategoryMenuBarListCategoryItem class]]) {
            self.listCategoryItem = category;
            self.listOptions = options;
        } else if ([category isKindOfClass:[TTCategoryMenuBarSectionCategoryItem class]]) {
            self.sectionCategoryItem = category;
            self.sectionOptions = options;
        }
        _options = options;
        [self loadSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationDidChange)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectIsEmpty(self.frame) && self.shouldInvalidateIntrnsicContentSize) {
        [self invalidateIntrinsicContentSize];
        self.shouldInvalidateIntrnsicContentSize = NO;
    }
}

- (void)statusBarOrientationDidChange {
    self.shouldInvalidateIntrnsicContentSize = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadSubviews {
    UIButton *doneButton;
    UIButton *resetButton;
    if (self.listCategoryItem.childAllowsMultipleSelection) {
        doneButton = [self loadDoneButton];
        [self addSubview:doneButton];
        self.doneButton = doneButton;
    }
    if (self.listCategoryItem.allowsReset) {
        resetButton = [self loadResetButton];
        [self addSubview:resetButton];
        self.resetButton = resetButton;
    }
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(@(TTCategoryMenuBarDoneButtonHeight));
        if (!doneButton) {
            make.right.equalTo(self);
        }
    }];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.equalTo(@(TTCategoryMenuBarDoneButtonHeight));
        if (resetButton) {
            make.left.equalTo(resetButton.mas_right);
            make.width.equalTo(resetButton);
        } else {
            make.left.equalTo(self);
        }
    }];
}

- (UIButton *)loadDoneButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = TTCategoryMenuBarBlueColor();
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)loadResetButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = TTCategoryMenuBarGrayColor();
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitle:@"重置" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UITableView *)loadTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[TTCategoryMenuBarCell class] forCellReuseIdentifier:TTCategoryMenuBarCellID];
    return tableView;
}

- (void)commit {
    if ([self.delegate respondsToSelector:@selector(categoryBarOptionView:didCommitOptions:)]) {
        [self.delegate categoryBarOptionView:self didCommitOptions:self.selectedOptions];
    }
}

- (void)reset {
    for (TTCategoryMenuBarOptionItem *option in self.listOptions) {
        [self resetOption:option];
    }
    [self selectedOptionsDidChange];
    [self reloadData];
    if ([self.delegate respondsToSelector:@selector(categoryBarOptionViewDidResetOptions:)]) {
        [self.delegate categoryBarOptionViewDidResetOptions:self];
    }
}

- (void)resetOption:(TTCategoryMenuBarOptionItem *)option {
    if ([option respondsToSelector:@selector(setIsSelected:)]) {
        [(id)option setIsSelected:NO];
    }
    option.isChildrenAllSelected = NO;
    [option.selectedChildOptions removeAllObjects];
    for (TTCategoryMenuBarListOptionItem *child in option.childOptions) {
        [self resetOption:child];
    }
}

- (void)clearSelectedOption:(TTCategoryMenuBarOptionItem *)option {
    [option.selectedChildOptions removeAllObjects];
    option.selectedChildOptions = nil;
    for (TTCategoryMenuBarListOptionItem *child in option.childOptions) {
        [self clearSelectedOption:child];
    }
}

- (void)selectedOptionsDidChange {
    [self clearSelectedOptions];
    if ([self.delegate respondsToSelector:@selector(categoryBarOptionView:selectedOptionsDidChange:)]) {
        [self.delegate categoryBarOptionView:self selectedOptionsDidChange:[self selectedOptions]];
    }
}

- (void)reloadData {}

- (TTCategoryMenuBarListOptionItem *)optionAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCategoryMenuBarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.option = [self optionAtIndexPath:indexPath inTableView:tableView];
    cell.separatorLine.hidden = !self.listCategoryItem.showSeparatorAtLast && indexPath.row == [tableView numberOfRowsInSection:0] - 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self optionAtIndexPath:indexPath inTableView:tableView].optionRowHeight;
}

- (NSArray *)selectedOptions {
    if (_selectedOptions) {
        return _selectedOptions;
    }
    NSMutableArray *array = [NSMutableArray array];
    NSArray *options;
    if (self.listOptions) {
        options = self.listOptions;
    } else {
        options = self.sectionOptions;
    }
    for (TTCategoryMenuBarOptionItem *option in options) {
        BOOL added = NO;
        if (self.listCategoryItem.style == TTCategoryMenuBarCategoryStyleSingleList && [self isOptionSelected:option]) {
            added = YES;
            [array addObject:option];
        }
        // 如果子选项选中了，把他也包含进去
        if ([self loadSelectedChildInOption:option] && !added) {
            [array addObject:option];
        }
    }
    _selectedOptions = array.copy;
    return _selectedOptions;
}

- (void)clearSelectedOptions {
    // 先清除之前记录的选中列表，重新计算
    for (TTCategoryMenuBarOptionItem *option in _selectedOptions) {
        [self clearSelectedOption:option];
    }
    self.selectedOptions = nil;
}

- (BOOL)loadSelectedChildInOption:(TTCategoryMenuBarOptionItem *)option {
    if (option.childOptions.count) {
        for (TTCategoryMenuBarOptionItem *child in option.childOptions) {
            if ([self loadSelectedChildInOption:child]) {
                [option.selectedChildOptions addObject:child];
            }
        }
        return option.selectedChildOptions.count;
    } else {
        return [self isOptionSelected:option];
    }
}

- (BOOL)isOptionSelected:(__kindof TTCategoryMenuBarOptionItem *)option {
    if ([option respondsToSelector:@selector(isSelected)]) {
        return [(id)option isSelected];
    }
    return NO;
}

- (void)selectAllOptions:(NSArray *)options isSelect:(BOOL)isSelect inTableView:(UITableView *)tableView {
    [tableView reloadData];
    for (NSInteger row = 0; row < options.count; row ++) {
        TTCategoryMenuBarListOptionChildItem *child = options[row];
        child.isSelected = isSelect;
        [self refreshCellAtRow:row inTableView:tableView];
        if (isSelect) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)deselectOptionAtRow:(NSInteger)row inTableView:(UITableView *)tableView {
    [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO];
    [self refreshCellAtRow:row inTableView:tableView];
}

- (void)refreshCellAtRow:(NSInteger)row inTableView:(UITableView *)tableView {
    TTCategoryMenuBarCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setOption:cell.option];
}

- (CGFloat)maxHeight {
    UIView *superview = self.superview;
    NSString *menuBarClassName = @"TTCategoryMenuBar";
    CGFloat menuBarBottom = 0;
    while (superview) {
        NSString *superviewClassName = NSStringFromClass(superview.class);
        if ([superviewClassName isEqualToString:menuBarClassName]) {
            menuBarBottom = CGRectGetMaxY(superview.frame);
        }
        // self或者是TTCategoryMenuBar的容器
        if (![superviewClassName hasPrefix:menuBarClassName]) {
            break;
        }
        superview = superview.superview;
    }
    CGFloat containerViewHeight = superview.frame.size.height - menuBarBottom;
    return containerViewHeight <= 0 ? TTCategoryMenuBarScreenHeight : containerViewHeight;
}

@end

@interface TTCategoryMenuBarSingleListOptionView ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTCategoryMenuBarSingleListOptionView

- (void)loadSubviews {
    [super loadSubviews];
    self.tableView = [self loadTableView];
    self.tableView.allowsMultipleSelection = self.listCategoryItem.childAllowsMultipleSelection;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        UIButton *bottomButton = self.doneButton ?: self.resetButton;
        make.bottom.equalTo(self).offset(bottomButton ? -TTCategoryMenuBarDoneButtonHeight : 0);
        if (self.listCategoryItem.optionListWidth) {
            make.width.equalTo(@(self.listCategoryItem.optionListWidth));
        } else {
            make.width.equalTo(self);
        }
    }];
    [self reloadData];
}

- (void)reloadData {
    [self.tableView reloadData];
    for (NSInteger row = 0; row < self.listOptions.count; row ++) {
        TTCategoryMenuBarListOptionItem *option = self.listOptions[row];
        if (option.isSelected) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOptions.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果不支持多选，直接消失
    if (!self.listCategoryItem.childAllowsMultipleSelection) {
        self.listOptions[indexPath.row].isSelected = YES;
        [self refreshCellAtRow:indexPath.row inTableView:tableView];
        [self selectedOptionsDidChange];
        if ([self.delegate respondsToSelector:@selector(categoryBarOptionView:didCommitOptions:)]) {
            [self.delegate categoryBarOptionView:self didCommitOptions:@[self.listOptions[indexPath.row]]];
        }
        return;
    }
    // 已经选中则取消选中
    if (self.listOptions[indexPath.row].isSelected) {
        self.listOptions[indexPath.row].isSelected = NO;
        [self deselectOptionAtRow:indexPath.row inTableView:tableView];
    } else {
        self.listOptions[indexPath.row].isSelected = YES;
        [self refreshCellAtRow:indexPath.row inTableView:tableView];
    }
    [self selectedOptionsDidChange];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.listOptions[indexPath.row].isSelected = NO;
    [self refreshCellAtRow:indexPath.row inTableView:tableView];
    [self selectedOptionsDidChange];
}

- (TTCategoryMenuBarListOptionItem *)optionAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    return self.listOptions[indexPath.row];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGFloat listHeight = 0;
    for (TTCategoryMenuBarListOptionItem *option in self.listOptions) {
        listHeight += option.optionRowHeight;
    }
    UIButton *bottomButton = self.doneButton ?: self.resetButton;
    CGFloat maxHeight = MIN(self.listCategoryItem.optionViewPreferredMaxHeight, [self maxHeight]);
    return CGSizeMake(TTCategoryMenuBarScreenWidth, MIN(maxHeight, listHeight + bottomButton.frame.size.height));
}

@end

@interface TTCategoryMenuBarDoubleListOptionView ()

@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;

@end

@implementation TTCategoryMenuBarDoubleListOptionView

- (void)loadSubviews {
    [super loadSubviews];

    self.firstTableView = [self loadTableView];
    self.secondTableView = [self loadTableView];
    [self addSubview:self.firstTableView];
    [self addSubview:self.secondTableView];

    [self.firstTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        UIButton *bottomButton = self.doneButton ?: self.resetButton;
        make.bottom.equalTo(self).offset(bottomButton ? -TTCategoryMenuBarDoneButtonHeight : 0);
        if (self.listCategoryItem.optionListWidth) {
            make.width.equalTo(@(self.listCategoryItem.optionListWidth));
        } else {
            make.width.equalTo(self).multipliedBy(self.listCategoryItem.optionListWidthMultiply);
        }
    }];
    [self.secondTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTableView);
        UIButton *bottomButton = self.doneButton ?: self.resetButton;
        make.bottom.equalTo(self).offset(bottomButton ? -TTCategoryMenuBarDoneButtonHeight : 0);
        make.left.equalTo(self.firstTableView.mas_right);
        make.right.equalTo(self);
    }];

    [self reloadData];
}

- (void)reloadData {
    NSInteger selectedRow = 0;
    for (NSInteger row = 0; row < self.listOptions.count; row ++) {
        if (self.listOptions[row].isSelected) {
            selectedRow = row;
            break;
        }
    }
    if (!selectedRow) {
        self.listOptions.firstObject.isSelected = YES;
    }
    [self.firstTableView reloadData];
    [self.firstTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]
                                     animated:NO
                               scrollPosition:UITableViewScrollPositionNone];
    [self reloadSecondAtRow:selectedRow];
}

- (void)reloadSecondAtRow:(NSInteger)row {
    [self.secondTableView reloadData];
    self.secondTableView.allowsMultipleSelection = self.listOptions[row].childAllowsMultipleSelection;
    for (NSInteger childRow = 0; childRow < self.listOptions[row].childOptions.count; childRow ++) {
        TTCategoryMenuBarListOptionItem *option = self.listOptions[row].childOptions[childRow];
        if (option.isSelected) {
            [self.secondTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:childRow inSection:0]
                                              animated:NO
                                        scrollPosition:UITableViewScrollPositionNone];
        }
    }
    [self.secondTableView setContentOffset:CGPointZero animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return self.listOptions.count;
    }
    return [self showingChildOptions].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        // 当前在选中，不做处理
        if (self.listOptions[indexPath.row].isSelected) {
            return;
        }
        self.listOptions[indexPath.row].isSelected = YES;
        [self refreshCellAtRow:indexPath.row inTableView:tableView];
        // 刷新第二栏，并滚动到顶部
        [self reloadSecondAtRow:indexPath.row];
    } else {
        NSArray<TTCategoryMenuBarListOptionChildItem *> *childOptions = [self showingChildOptions];
        TTCategoryMenuBarListOptionChildItem *currentOption = childOptions[indexPath.row];
        currentOption.isSelected = YES;
        // 点击到选择全部
        if (currentOption.isSelectAll) {
            // 全选
            [self selectAllOptions:childOptions isSelect:YES inTableView:tableView];
        } else {
            // 如果是单选
            if (!tableView.allowsMultipleSelection) {
                [self selectedOptionsDidChange];
                if ([self.delegate respondsToSelector:@selector(categoryBarOptionView:didCommitOptions:)]) {
                    [self.delegate categoryBarOptionView:self didCommitOptions:@[currentOption]];
                }
                return;
            }
            // 找到全选cell
            TTCategoryMenuBarListOptionChildItem *selectAllOption = childOptions.firstObject.isSelectAll ? childOptions.firstObject : nil;
            if (selectAllOption) {
                BOOL isSelectAlled = YES;
                for (TTCategoryMenuBarListOptionChildItem *child in childOptions) {
                    if (child != selectAllOption && !child.isSelected) {
                        isSelectAlled = NO;
                        break;
                    }
                }
                if (isSelectAlled) {
                    // 全部选中了则选中全选的cell
                    selectAllOption.isSelected = YES;
                    [self selectAllOptions:childOptions isSelect:YES inTableView:tableView];
                } else {
                    [self refreshCellAtRow:indexPath.row inTableView:tableView];
                }
            } else {
                [self refreshCellAtRow:indexPath.row inTableView:tableView];
            }
        }
        [self selectedOptionsDidChange];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        self.listOptions[indexPath.row].isSelected = NO;
        [self refreshCellAtRow:indexPath.row inTableView:tableView];
    } else {
        NSArray<TTCategoryMenuBarListOptionChildItem *> *childOptions = [self showingChildOptions];
        TTCategoryMenuBarListOptionChildItem *currentOption = childOptions[indexPath.row];
        currentOption.isSelected = NO;
        // 取消全选
        if (currentOption.isSelectAll) {
            [self selectAllOptions:childOptions isSelect:NO inTableView:tableView];
        } else {
            [self refreshCellAtRow:indexPath.row inTableView:tableView];
            // 找到全选cell
            TTCategoryMenuBarListOptionChildItem *selectAllOption = childOptions.firstObject.isSelectAll ? childOptions.firstObject : nil;
            if (selectAllOption) {
                // 取消选中全选的cell
                selectAllOption.isSelected = NO;
                [self deselectOptionAtRow:0 inTableView:tableView];
                self.listOptions[self.firstTableView.indexPathForSelectedRow.row].isChildrenAllSelected = NO;
            }
        }
        [self selectedOptionsDidChange];
    }
}

- (void)selectAllOptions:(NSArray *)options isSelect:(BOOL)isSelect inTableView:(UITableView *)tableView {
    [super selectAllOptions:options isSelect:isSelect inTableView:tableView];
    // 子选项全部选中
    self.listOptions[self.firstTableView.indexPathForSelectedRow.row].isChildrenAllSelected = isSelect;
}

- (TTCategoryMenuBarListOptionItem *)optionAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    if (tableView == self.firstTableView) {
        return self.listOptions[indexPath.row];
    }
    return [self showingChildOptions][indexPath.row];
}

- (NSArray<TTCategoryMenuBarListOptionChildItem *> *)showingChildOptions {
    return self.listOptions[self.firstTableView.indexPathForSelectedRow.row].childOptions;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGFloat firstListHeight = 0;
    CGFloat secondListHeight = 0;
    for (TTCategoryMenuBarListOptionItem *option in self.listOptions) {
        firstListHeight += option.optionRowHeight;
    }
    for (TTCategoryMenuBarListOptionItem *option in [self showingChildOptions]) {
        secondListHeight += option.optionRowHeight;
    }
    CGFloat listHeight = MAX(firstListHeight, secondListHeight);
    UIButton *bottomButton = self.doneButton ?: self.resetButton;
    CGFloat maxHeight = MIN(self.listCategoryItem.optionViewPreferredMaxHeight, [self maxHeight]);
    return CGSizeMake(TTCategoryMenuBarScreenWidth, MIN(maxHeight, listHeight + bottomButton.frame.size.height));
}

@end

@interface TTCategoryMenuBarTripleListOptionView ()

@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, strong) UITableView *thirdTableView;

@end

@implementation TTCategoryMenuBarTripleListOptionView

- (void)loadSubviews {
    [super loadSubviews];

    self.firstTableView = [self loadTableView];
    self.secondTableView = [self loadTableView];
    self.thirdTableView = [self loadTableView];
    [self addSubview:self.firstTableView];
    [self addSubview:self.secondTableView];
    [self addSubview:self.thirdTableView];

    [self.firstTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        UIButton *bottomButton = self.doneButton ?: self.resetButton;
        make.bottom.equalTo(self).offset(bottomButton ? -TTCategoryMenuBarDoneButtonHeight : 0);
        if (self.listCategoryItem.optionListWidth) {
            make.width.equalTo(@(self.listCategoryItem.optionListWidth));
        } else {
            make.width.equalTo(self).multipliedBy(self.listCategoryItem.optionListWidthMultiply);
        }
    }];
    [self.secondTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTableView);
        UIButton *bottomButton = self.doneButton ?: self.resetButton;
        make.bottom.equalTo(self).offset(bottomButton ? -TTCategoryMenuBarDoneButtonHeight : 0);
        make.left.equalTo(self.firstTableView.mas_right);
        if (self.listCategoryItem.optionListWidth) {
            make.width.equalTo(@(self.listCategoryItem.secondOptionListWidth));
        } else {
            make.width.equalTo(self).multipliedBy(self.listCategoryItem.secondOptionListWidthMultiply);
        }
    }];
    [self.thirdTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstTableView);
        UIButton *bottomButton = self.doneButton ?: self.resetButton;
        make.bottom.equalTo(self).offset(bottomButton ? -TTCategoryMenuBarDoneButtonHeight : 0);
        make.left.equalTo(self.secondTableView.mas_right);
        make.right.equalTo(self);
    }];

    [self reloadData];
}

- (void)reloadData {
    NSInteger selectedRow = 0;
    for (NSInteger row = 0; row < self.listOptions.count; row ++) {
        if (self.listOptions[row].isSelected) {
            selectedRow = row;
            break;
        }
    }
    if (!selectedRow) {
        self.listOptions.firstObject.isSelected = YES;
    }
    [self.firstTableView reloadData];
    [self.firstTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]
                                     animated:NO
                               scrollPosition:UITableViewScrollPositionNone];
    [self reloadSecondAtRow:selectedRow];
}

- (void)reloadSecondAtRow:(NSInteger)row {
    NSArray<TTCategoryMenuBarListOptionChildItem *> *secondShowingChildOptions = [self secondShowingChildOptions];
    for (TTCategoryMenuBarListOptionChildItem *option in secondShowingChildOptions) {
        option.isSelected = NO;
    }
    secondShowingChildOptions.firstObject.isSelected = YES;
    [self.secondTableView reloadData];
//    self.secondTableView.allowsMultipleSelection = self.listOptions[row].childAllowsMultipleSelection;
    for (NSInteger childRow = 0; childRow < secondShowingChildOptions.count; childRow ++) {
        TTCategoryMenuBarListOptionItem *option = secondShowingChildOptions[childRow];
        if (option.isSelected) {
            [self.secondTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:childRow inSection:0]
                                              animated:NO
                                        scrollPosition:UITableViewScrollPositionNone];
        }
    }
    [self.secondTableView setContentOffset:CGPointZero animated:NO];
    [self reloadThirdAtRow:0];
}

- (void)reloadThirdAtRow:(NSInteger)row {
    [self.thirdTableView reloadData];
    NSArray *thirdShowingChildOptions = [self thirdShowingChildOptions];
    if (!thirdShowingChildOptions.count) {
        return;
    }
    TTCategoryMenuBarListOptionItem *parentOption = [self secondShowingChildOptions][self.secondTableView.indexPathForSelectedRow.row];
    self.thirdTableView.allowsMultipleSelection = parentOption.childAllowsMultipleSelection;
    for (NSInteger childRow = 0; childRow < thirdShowingChildOptions.count; childRow ++) {
        TTCategoryMenuBarListOptionItem *option = thirdShowingChildOptions[childRow];
        if (option.isSelected) {
            [self.thirdTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:childRow inSection:0]
                                             animated:NO
                                       scrollPosition:UITableViewScrollPositionNone];
        }
    }
    [self.thirdTableView setContentOffset:CGPointZero animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firstTableView) {
        return self.listOptions.count;
    } else if (tableView == self.secondTableView) {
        return [self secondShowingChildOptions].count;
    }
    return [self thirdShowingChildOptions].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        // 当前在选中，不做处理
        if (self.listOptions[indexPath.row].isSelected) {
            return;
        }
        self.listOptions[indexPath.row].isSelected = YES;
        [self refreshCellAtRow:indexPath.row inTableView:tableView];
        // 刷新第二栏，并滚动到顶部
        [self reloadSecondAtRow:indexPath.row];
    } else if (tableView == self.secondTableView) {
        NSArray<TTCategoryMenuBarListOptionChildItem *> *childOptions = [self secondShowingChildOptions];
//        TTCategoryMenuBarListOptionChildItem *currentOption = childOptions[indexPath.row];
//        // 全选
//        if (tableView.allowsMultipleSelection && currentOption.isSelectAll) {
//            currentOption.isSelected = YES;
//            [self selectAllOptions:childOptions isSelect:YES inTableView:tableView];
//        } else {
//            NSArray<TTCategoryMenuBarListOptionChildItem *> *childOptions = [self secondShowingChildOptions];
            // 当前在选中，不做处理
            if (childOptions[indexPath.row].isSelected) {
                return;
            }
            childOptions[indexPath.row].isSelected = YES;
            [self refreshCellAtRow:indexPath.row inTableView:tableView];
            // 刷新第二栏，并滚动到顶部
            [self reloadThirdAtRow:indexPath.row];
//        }
    } else {
        NSArray<TTCategoryMenuBarListOptionChildItem *> *childOptions = [self thirdShowingChildOptions];
        TTCategoryMenuBarListOptionChildItem *currentOption = childOptions[indexPath.row];
        currentOption.isSelected = YES;
        // 如果是单选
        if (!tableView.allowsMultipleSelection) {
            [self selectedOptionsDidChange];
            if ([self.delegate respondsToSelector:@selector(categoryBarOptionView:didCommitOptions:)]) {
                [self.delegate categoryBarOptionView:self didCommitOptions:@[currentOption]];
            }
            return;
        }
        // 点击到选择全部
        if (currentOption.isSelectAll) {
            // 全选
            [self selectAllOptions:childOptions isSelect:YES inTableView:tableView];
        } else {
            // 找到全选cell
            TTCategoryMenuBarListOptionChildItem *selectAllOption = childOptions.firstObject.isSelectAll ? childOptions.firstObject : nil;
            if (selectAllOption) {
                BOOL isSelectAlled = YES;
                for (TTCategoryMenuBarListOptionChildItem *child in childOptions) {
                    if (child != selectAllOption && !child.isSelected) {
                        isSelectAlled = NO;
                        break;
                    }
                }
                if (isSelectAlled) {
                    // 全部选中了则选中全选的cell
                    selectAllOption.isSelected = YES;
                    [self selectAllOptions:childOptions isSelect:YES inTableView:tableView];
                } else {
                    [self refreshCellAtRow:indexPath.row inTableView:tableView];
                }
            } else {
                [self refreshCellAtRow:indexPath.row inTableView:tableView];
            }
        }
        [self selectedOptionsDidChange];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstTableView) {
        self.listOptions[indexPath.row].isSelected = NO;
        [self refreshCellAtRow:indexPath.row inTableView:tableView];
    } else if (tableView == self.secondTableView) {
        NSArray<TTCategoryMenuBarListOptionChildItem *> *childOptions = [self secondShowingChildOptions];
        childOptions[indexPath.row].isSelected = NO;
        [self refreshCellAtRow:indexPath.row inTableView:tableView];
    } else {
        NSArray<TTCategoryMenuBarListOptionChildItem *> *childOptions = [self thirdShowingChildOptions];
        TTCategoryMenuBarListOptionChildItem *currentOption = childOptions[indexPath.row];
        currentOption.isSelected = NO;
        // 取消全选
        if (currentOption.isSelectAll) {
            [self selectAllOptions:childOptions isSelect:NO inTableView:tableView];
        } else {
            [self refreshCellAtRow:indexPath.row inTableView:tableView];
            // 找到全选cell
            TTCategoryMenuBarListOptionChildItem *selectAllOption = childOptions.firstObject.isSelectAll ? childOptions.firstObject : nil;
            if (selectAllOption) {
                // 取消选中全选的cell
                selectAllOption.isSelected = NO;
                [self deselectOptionAtRow:0 inTableView:tableView];
                self.listOptions[self.firstTableView.indexPathForSelectedRow.row].isChildrenAllSelected = NO;
            }
        }
        [self selectedOptionsDidChange];
    }
}

- (void)selectAllOptions:(NSArray *)options isSelect:(BOOL)isSelect inTableView:(UITableView *)tableView {
    [super selectAllOptions:options isSelect:isSelect inTableView:tableView];
    // 子选项全部选中
    if (tableView == self.thirdTableView) {
        NSArray<TTCategoryMenuBarListOptionChildItem *> *secondShowingChildOptions = [self secondShowingChildOptions];
        secondShowingChildOptions[self.secondTableView.indexPathForSelectedRow.row].isChildrenAllSelected = isSelect;
        if (isSelect) {
            BOOL isSecondAllSelect = YES;
            for (TTCategoryMenuBarListOptionChildItem *option in secondShowingChildOptions) {
                if (!option.isSelected) {
                    isSecondAllSelect = NO;
                    break;
                }
            }
            self.listOptions[self.firstTableView.indexPathForSelectedRow.row].isChildrenAllSelected = isSecondAllSelect;
        }
    } else if (tableView == self.secondTableView) {
        self.listOptions[self.firstTableView.indexPathForSelectedRow.row].isChildrenAllSelected = isSelect;
        NSArray<TTCategoryMenuBarListOptionChildItem *> *secondShowingChildOptions = [self secondShowingChildOptions];
        for (NSInteger i = 0; i < secondShowingChildOptions.count; i++) {
            TTCategoryMenuBarListOptionChildItem *secondChild = secondShowingChildOptions[i];
            secondChild.isChildrenAllSelected = isSelect;
            NSArray<TTCategoryMenuBarListOptionChildItem *> *thirdChildOptions = secondShowingChildOptions[i].childOptions;
            for (TTCategoryMenuBarListOptionChildItem *child in thirdChildOptions) {
                child.isSelected = isSelect;
            }
        }
    }
}

- (TTCategoryMenuBarListOptionItem *)optionAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    if (tableView == self.firstTableView) {
        return self.listOptions[indexPath.row];
    } else if (tableView == self.secondTableView) {
        return [self secondShowingChildOptions][indexPath.row];
    } else {
        return [self thirdShowingChildOptions][indexPath.row];
    }
}

- (NSArray<TTCategoryMenuBarListOptionChildItem *> *)secondShowingChildOptions {
    return self.listOptions[self.firstTableView.indexPathForSelectedRow.row].childOptions;
}

- (NSArray<TTCategoryMenuBarListOptionChildItem *> *)thirdShowingChildOptions {
    NSArray<TTCategoryMenuBarListOptionChildItem *> *secondShowingChildOptions = [self secondShowingChildOptions];
    if (secondShowingChildOptions.count > self.secondTableView.indexPathForSelectedRow.row) {
        return secondShowingChildOptions[self.secondTableView.indexPathForSelectedRow.row].childOptions;
    }
    return nil;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGFloat firstListHeight = 0;
    CGFloat secondListHeight = 0;
    CGFloat thirdListHeight = 0;
    for (TTCategoryMenuBarListOptionItem *option in self.listOptions) {
        firstListHeight += option.optionRowHeight;
    }
    for (TTCategoryMenuBarListOptionItem *option in [self secondShowingChildOptions]) {
        secondListHeight += option.optionRowHeight;
    }
    for (TTCategoryMenuBarListOptionItem *option in [self thirdShowingChildOptions]) {
        thirdListHeight += option.optionRowHeight;
    }
    CGFloat listHeight = MAX(MAX(firstListHeight, secondListHeight), thirdListHeight);
    UIButton *bottomButton = self.doneButton ?: self.resetButton;
    CGFloat maxHeight = MIN([self maxHeight], self.listCategoryItem.optionViewPreferredMaxHeight);
    return CGSizeMake(TTCategoryMenuBarScreenWidth, MIN(maxHeight, listHeight + bottomButton.frame.size.height));
}

@end

@interface TTCategoryMenuBarSectionListLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, assign) BOOL shouldAlignmentLeft;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat collectionViewWidthWhenLastPrepare;

@end

@implementation TTCategoryMenuBarSectionListLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

    }
    return self;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(TTCategoryMenuBarScreenWidth, self.contentHeight);
}

- (void)prepareLayout {
    [super prepareLayout];

    if (self.collectionViewWidthWhenLastPrepare && self.collectionViewWidthWhenLastPrepare == self.collectionView.frame.size.width) {
        return;
    }
    self.collectionViewWidthWhenLastPrepare = self.collectionView.frame.size.width;

    self.attributes = [[NSMutableArray alloc] init];

    @autoreleasepool {
        CGFloat lastRight = 0, lastBottom = 0;
        for (NSInteger section = 0, number = [self numberOfSections]; section < number; section ++) {
            CGFloat lineSpacing = [self lineSpacingInSection:section];
            CGFloat interitemSpacing = [self interitemSpacingInSection:section];
            UIEdgeInsets insets = [self edgeInsetsInSection:section];
            CGFloat layoutWidth = self.collectionView.frame.size.width - insets.left - insets.right;

            NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            CGSize headerSize = [self headerSizeForSection:section];
            headerSize.width = MIN(layoutWidth, headerSize.width);
            UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
            headerAttributes.frame = (CGRect){.origin = CGPointMake(0, lastBottom), .size = headerSize};
            [self.attributes addObject:headerAttributes];
            lastBottom += headerSize.height;

            for (NSInteger row = 0, rowNumber = [self numberOfRowsInSection:section]; row < rowNumber; row ++) {
                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:row inSection:section];
                CGSize itemSize = [self itemSizeForIndexPath:itemIndexPath];
                itemSize.width = MIN(layoutWidth, itemSize.width);
                UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
                if (!row) {
                    itemAttributes.frame = (CGRect){.origin = CGPointMake(insets.left, lastBottom), .size = itemSize};
                    lastRight = insets.left + itemSize.width;
                } else if (lastRight + interitemSpacing + itemSize.width > layoutWidth) {
                    // 下一行
                    lastBottom += itemSize.height + lineSpacing;
                    lastRight = insets.left;
                    itemAttributes.frame = (CGRect){.origin = CGPointMake(lastRight, lastBottom), .size = itemSize};
                    lastRight += itemSize.width;
                } else {
                    // 同一行
                    lastRight += interitemSpacing;
                    itemAttributes.frame = (CGRect){.origin = CGPointMake(lastRight, lastBottom), .size = itemSize};
                    lastRight += itemSize.width;
                }
                if (row == rowNumber - 1) {
                    lastBottom = CGRectGetMaxY(itemAttributes.frame);
                }
                [self.attributes addObject:itemAttributes];
            }
        }
    }

    UICollectionViewLayoutAttributes *lastAttributes = self.attributes.lastObject;
    self.contentHeight = CGRectGetMaxY(lastAttributes.frame);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.attributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *attribute, NSDictionary<NSString *,id> * _Nullable bindings) {
        return CGRectIntersectsRect(rect, attribute.frame);
    }]];
}

#define DelegateFlowLayout (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate

- (NSInteger)numberOfSections {
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
    }
    return 0;
}

- (CGSize)headerSizeForSection:(NSInteger)section {
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [DelegateFlowLayout collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    return self.headerReferenceSize;
}

- (UIEdgeInsets)edgeInsetsInSection:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [DelegateFlowLayout collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return self.sectionInset;
}

- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath {
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [DelegateFlowLayout collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return self.itemSize;
}

- (CGFloat)interitemSpacingInSection:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [DelegateFlowLayout collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.minimumInteritemSpacing;
}

- (CGFloat)lineSpacingInSection:(NSInteger)section {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [DelegateFlowLayout collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.minimumLineSpacing;
}

- (void)didReceiveMemoryWarning {
    [self.attributes removeAllObjects];
    self.attributes = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end

@interface TTCategoryMenuBarSectionListHeader : UICollectionReusableView
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) TTCategoryMenuBarSectionItem *section;
@end

@implementation TTCategoryMenuBarSectionListHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.containerView = [[UIView alloc] init];
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        self.textLabel = [[UILabel alloc] init];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.imageView];
        [self.containerView addSubview:self.textLabel];
    }
    return self;
}

- (void)setSection:(TTCategoryMenuBarSectionItem *)section {
    BOOL accessoryChanged = NO;
    if (!_section || !UIEdgeInsetsEqualToEdgeInsets(section.sectionInset, _section.sectionInset)) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(section.sectionInset);
        }];
    }
    if (!self.accessoryImageView && (section.accessoryIcon || section.selectedAccessoryIcon)) {
        accessoryChanged = YES;
        self.accessoryImageView = [[UIImageView alloc] init];
        [self.accessoryImageView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                                 forAxis:UILayoutConstraintAxisHorizontal];
        [self.containerView addSubview:self.accessoryImageView];
        [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.right.equalTo(self.containerView);
        }];
    }
    if (!_section ||
        (BOOL)section.icon != (BOOL)_section.icon ||
        (BOOL)section.selectedIcon != (BOOL)_section.selectedIcon ||
        section.iconTitleSpace != _section.iconTitleSpace ||
        accessoryChanged) {
        if (section.icon && section.iconTitleSpace >= 0) {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.containerView);
                make.left.equalTo(self.containerView);
            }];
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.containerView);
                make.left.equalTo(self.imageView.mas_right).offset(section.iconTitleSpace);
                if (self.accessoryImageView) {
                    make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left).offset(-10);
                } else {
                    make.right.lessThanOrEqualTo(self.containerView);
                }
            }];
        } else if (section.icon && section.iconTitleSpace < 0) {
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.containerView);
                make.left.equalTo(self.containerView);
            }];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self.textLabel.mas_right).offset(-section.iconTitleSpace);
                if (self.accessoryImageView) {
                    make.right.lessThanOrEqualTo(self.accessoryImageView.mas_left).offset(-10);
                } else {
                    make.right.lessThanOrEqualTo(self.containerView);
                }
            }];
        } else {
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.containerView);
            }];
        }
    }
    _section = section;
    self.accessoryImageView.image = section.accessoryIcon;
    self.textLabel.attributedText = section.attributedTitle ?: [[NSAttributedString alloc] initWithString:(section.title ?: @"")
                                                                                               attributes:section.titleAttributes];
    self.imageView.image = section.icon;
}

@end

@interface TTCategoryMenuBarSectionListCell : UICollectionViewCell
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) TTCategoryMenuBarSectionOptionItem *option;
@end

@implementation TTCategoryMenuBarSectionListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.containerView = [[UIView alloc] init];
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        self.textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.imageView];
        [self.containerView addSubview:self.textLabel];
    }
    return self;
}

- (void)setOption:(TTCategoryMenuBarSectionOptionItem *)option {
    if (!_option || !UIEdgeInsetsEqualToEdgeInsets(option.inset, _option.inset)) {
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(option.inset);
        }];
    }
    if (!_option ||
        (BOOL)option.icon != (BOOL)_option.icon ||
        (BOOL)option.selectedIcon != (BOOL)_option.selectedIcon ||
        option.iconTitleSpace != _option.iconTitleSpace) {
        if (option.icon && option.iconTitleSpace >= 0) {
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.left.equalTo(self.containerView);
            }];
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.containerView);
                make.left.equalTo(self.imageView.mas_right).offset(option.iconTitleSpace);
                make.right.equalTo(self.containerView);
            }];
        } else if (option.icon && option.iconTitleSpace < 0) {
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.equalTo(self.containerView);
            }];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.containerView);
                make.left.equalTo(self.textLabel.mas_right).offset(-option.iconTitleSpace);
                make.right.equalTo(self.containerView);
            }];
        } else {
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.containerView);
            }];
            [[MASViewConstraint installedConstraintsForView:self.imageView] makeObjectsPerformSelector:@selector(uninstall)];
        }
    }
    if (!_option || option.cornerRadius != _option.cornerRadius) {
        self.contentView.layer.cornerRadius = option.cornerRadius;
    }
    if (!_option || (option.borderWidth && option.borderWidth != _option.borderWidth)) {
        self.contentView.layer.borderWidth = option.borderWidth;
    }
    _option = option;
    if (option.isSelected) {
        self.imageView.image = option.icon;
        self.textLabel.attributedText = [option.selectedAttributedTitle ?: [NSAttributedString alloc] initWithString:(option.title ?: @"")
                                                                                                          attributes:option.selectedTitleAttributes];
        self.contentView.layer.backgroundColor = option.selectBackgroundColor.CGColor;
        self.contentView.layer.borderColor = option.borderColor.CGColor;
    } else {
        self.imageView.image = option.icon;
        self.textLabel.attributedText = [option.attributedTitle ?: [NSAttributedString alloc] initWithString:(option.title ?: @"")
                                                                                                  attributes:option.titleAttributes];
        self.contentView.layer.backgroundColor = option.backgroundColor.CGColor;
        self.contentView.layer.borderColor = option.selectedBorderColor.CGColor;
    }
}

@end

@interface TTCategoryMenuBarSectionListView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TTCategoryMenuBarSectionListCell *layoutCell;

@end

@implementation TTCategoryMenuBarSectionListView

- (void)loadSubviews {
    [super loadSubviews];

    self.layoutCell = [[TTCategoryMenuBarSectionListCell alloc] init];

    TTCategoryMenuBarSectionListLayout *layout = [[TTCategoryMenuBarSectionListLayout alloc] init];
    layout.shouldAlignmentLeft = self.sectionCategoryItem.shouldAlignmentLeft;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.allowsMultipleSelection = self.sectionCategoryItem.childAllowsMultipleSelection;
    collectionView.backgroundColor = self.sectionCategoryItem.listBackgroundColor;
    [collectionView registerClass:[TTCategoryMenuBarSectionListHeader class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"header"];
    [collectionView registerClass:[TTCategoryMenuBarSectionListCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;

    [self addSubview:self.collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        UIButton *bottomButton = self.doneButton ?: self.resetButton;
        make.bottom.equalTo(self).offset(bottomButton ? -TTCategoryMenuBarDoneButtonHeight : 0);
    }];

    [self reloadData];
}

- (void)reloadData {
    [self.collectionView reloadData];
    for (NSInteger section = 0; section < self.sectionOptions.count; section ++) {
        TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[section];
        for (NSInteger index = 0; index < sectionItem.childOptions.count; index ++) {
            TTCategoryMenuBarSectionOptionItem *item = sectionItem.childOptions[index];
            if (item.isSelected) {
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section]
                                                  animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionOptions.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[section];
    return sectionItem.childOptions.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[section];
    return sectionItem.sectionInset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[section];
    return CGSizeMake(TTCategoryMenuBarScreenWidth - 20, sectionItem.sectionHeaderHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[section];
    return sectionItem.lineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[section];
    return sectionItem.interitemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[indexPath.section];
    TTCategoryMenuBarSectionOptionItem *item = sectionItem.childOptions[indexPath.row];
    CGSize size = item.size;
    if (CGSizeEqualToSize(item.size, CGSizeZero)) {
        size = sectionItem.itemSize;
    }
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        if (UIEdgeInsetsEqualToEdgeInsets(item.inset, UIEdgeInsetsZero)) {
            item.inset = sectionItem.itemInset;
        }
        self.layoutCell.option = item;
        size = [self.layoutCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        item.size = size;
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TTCategoryMenuBarSectionListHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.section = self.sectionOptions[indexPath.section];
        return header;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCategoryMenuBarSectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[indexPath.section];
    TTCategoryMenuBarSectionOptionItem *item = sectionItem.childOptions[indexPath.row];
    // 默认值
    if (!item.cornerRadius) {
        item.cornerRadius = sectionItem.itemCornerRadius;
    }
    if (!item.borderWidth) {
        item.borderWidth = sectionItem.itemBorderWidth;
    }
    if (!item.borderColor) {
        item.borderColor = sectionItem.itemBorderColor;
    }
    if (!item.selectedBorderColor) {
        item.selectedBorderColor = sectionItem.selectedItemBorderColor ?: item.borderColor;
    }
    cell.option = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[indexPath.section];
    NSArray<TTCategoryMenuBarSectionOptionItem *> *childOptions = (NSArray<TTCategoryMenuBarSectionOptionItem *> *)sectionItem.childOptions;
    TTCategoryMenuBarSectionOptionItem *item = sectionItem.childOptions[indexPath.row];
    item.isSelected = YES;
    // 点击到选择全部
    if (item.isSelectAll) {
        // 全选
        [self selectAllOptions:childOptions isSelect:YES inSection:indexPath.section];
    } else {
        // 找到全选cell
        TTCategoryMenuBarSectionOptionItem *selectAllOption = childOptions.firstObject.isSelectAll ? childOptions.firstObject : nil;
        if (selectAllOption) {
            BOOL isSelectAlled = YES;
            for (TTCategoryMenuBarSectionOptionItem *child in childOptions) {
                if (child != selectAllOption && !child.isSelected) {
                    isSelectAlled = NO;
                    break;
                }
            }
            if (isSelectAlled) {
                // 全部选中了则选中全选的cell
                selectAllOption.isSelected = YES;
                [self selectAllOptions:sectionItem.childOptions isSelect:YES inSection:indexPath.section];
            } else {
                selectAllOption.isSelected = NO;
                [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
                [self refreshItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [self refreshItemAtIndexPath:indexPath];
            }
        } else {
            [self refreshItemAtIndexPath:indexPath];
        }
    }
    [self selectedOptionsDidChange];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCategoryMenuBarSectionItem *sectionItem = self.sectionOptions[indexPath.section];
    NSArray<TTCategoryMenuBarSectionOptionItem *> *childOptions = (NSArray<TTCategoryMenuBarSectionOptionItem *> *)sectionItem.childOptions;
    TTCategoryMenuBarSectionOptionItem *currentOption = childOptions[indexPath.row];
    currentOption.isSelected = NO;
    // 取消全选
    if (currentOption.isSelectAll) {
        [self selectAllOptions:childOptions isSelect:NO inSection:indexPath.section];
    } else {
        [self refreshItemAtIndexPath:indexPath];
        // 找到全选cell
        TTCategoryMenuBarSectionOptionItem *selectAllOption = childOptions.firstObject.isSelectAll ? childOptions.firstObject : nil;
        if (selectAllOption) {
            // 取消选中全选的cell
            selectAllOption.isSelected = NO;
            [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
            [self refreshItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        self.sectionOptions[indexPath.section].isChildrenAllSelected = NO;
    }
    [self selectedOptionsDidChange];
}

- (void)selectAllOptions:(NSArray *)options isSelect:(BOOL)isSelect inSection:(NSInteger)section {
    [self.collectionView reloadData];
    for (NSInteger row = 0; row < options.count; row ++) {
        TTCategoryMenuBarSectionOptionItem *child = options[row];
        if (self.sectionOptions[section].unselectsOthersWhenSelectAll) {
            child.isSelected = child.isSelectAll && isSelect;
        } else {
            child.isSelected = isSelect;
        }
        [self refreshItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        if (child.isSelected) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]
                                              animated:NO
                                        scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    self.sectionOptions[section].isChildrenAllSelected = isSelect;
}

- (void)refreshItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCategoryMenuBarSectionListCell *cell = (TTCategoryMenuBarSectionListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setOption:cell.option];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    self.collectionView.frame = CGRectMake(0, 0, TTCategoryMenuBarScreenWidth, 0);
    [self.collectionView layoutIfNeeded];
    // 布局完成前提前获取collectionView的frame
    CGFloat listHeight = [self.collectionView contentSize].height;
    UIButton *bottomButton = self.doneButton ?: self.resetButton;
    CGFloat maxHeight = MIN(self.sectionCategoryItem.optionViewPreferredMaxHeight, [self maxHeight]);
    return CGSizeMake(TTCategoryMenuBarScreenWidth, MIN(maxHeight, listHeight + bottomButton.frame.size.height));
}

@end


