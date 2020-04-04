//
//  TTCategoryMenuItem.m
//  TTKit
//
//  Created by rollingstoneW on 2019/7/1.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTCategoryMenuItem.h"
#import "TTCategoryMenuBarUtil.h"

@implementation TTCategoryMenuBarCategoryItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                             NSForegroundColorAttributeName:TTCategoryMenuBarBlackColor()};
        _selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName:TTCategoryMenuBarBlueColor()};
        _iconTitleSpace = 10.f;
        _separatorLineColor = TTCategoryMenuBarLineColor();
        _separatorLineIndent = 10;
        _shouldIconAutoRotate = YES;
        _optionViewPreferredMaxHeight = TTCategoryMenuBarScreenHeight;
//        _scrollToFirstSelectedOptionPotisionWhenShow = UITableViewScrollPositionMiddle;
    }
    return self;
}

@end

@implementation TTCategoryMenuBarOptionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                             NSForegroundColorAttributeName:TTCategoryMenuBarBlackColor()};
        _selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                     NSForegroundColorAttributeName:TTCategoryMenuBarBlueColor()};
        _iconTitleSpace = 10;
    }
    return self;
}

- (NSMutableArray *)selectedChildOptions {
    if (!self.childOptions.count) {
        return nil;
    }
    if (!_selectedChildOptions) {
        _selectedChildOptions = [NSMutableArray array];
    }
    return _selectedChildOptions;
}

@end

@implementation TTCategoryMenuBarListCategoryItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.style = TTCategoryMenuBarCategoryStyleSingleList;
        _optionListWidthMultiply = _secondOptionListWidthMultiply = 0.33;
    }
    return self;
}

@end

@implementation TTCategoryMenuBarListOptionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _separatorLineColor = TTCategoryMenuBarLineColor();
        _backgroundColor = [UIColor whiteColor];
        _selectBackgroundColor = TTCategoryMenuBarBgColor();
        _optionRowHeight = 44;
        _tailIndent = 15;
    }
    return self;
}

@end

@implementation TTCategoryMenuBarListOptionChildItem
@end

@implementation TTCategoryMenuBarSectionCategoryItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.style = TTCategoryMenuBarCategoryStyleSectionList;
        _listBackgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

@implementation TTCategoryMenuBarSectionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _sectionHeaderHeight = 40;
        _sectionInset = UIEdgeInsetsMake(0, 15, 0 ,15);
        _headerInset = _sectionInset;
        _lineSpacing = 10;
        _interitemSpacing = 10;
        _itemInset = UIEdgeInsetsMake(5, 10, 5, 10);
        _itemCornerRadius = 3;
        _itemBackgroundColor = TTCategoryMenuBarBgColor();
        _selectItemBackgroundColor = TTCategoryMenuBarBgColor();
        _unselectsOthersWhenSelectAll = YES;
    }
    return self;
}

@end

@implementation TTCategoryMenuBarSectionOptionItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor whiteColor];
        _selectBackgroundColor = TTCategoryMenuBarBgColor();
        _enabled = YES;
    }
    return self;
}

@end

