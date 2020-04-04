//
//  TTCategoryMenuItem.h
//  TTKit
//
//  Created by rollingstoneW on 2019/7/1.
//  Copyright © 2019 TTKit. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 分类样式
 */
typedef NS_ENUM(NSUInteger, TTCategoryMenuBarCategoryStyle) {
    TTCategoryMenuBarCategoryStyleNoneData, // 此分类没有选项
    TTCategoryMenuBarCategoryStyleSingleList, // 单排列表样式，列表式
    TTCategoryMenuBarCategoryStyleDoubleList, // 双排列表样式，列表式
    TTCategoryMenuBarCategoryStyleTripleList, // 三排列表样式，列表式
    TTCategoryMenuBarCategoryStyleSectionList, // 多列分组样式，分组式
    TTCategoryMenuBarCategoryStyleCustom, // 自定义选项样式
};

#pragma mark - 基类，请使用对应子类
/**
 分类模型的基类，请使用TTCategoryMenuBarListCategoryItem或者TTCategoryMenuBarSectionCategoryItem，没有选项可以使用此类
 */
@interface TTCategoryMenuBarCategoryItem : NSObject

@property (nonatomic, assign) TTCategoryMenuBarCategoryStyle style; // 样式，默认是TTCategoryMenuBarCategoryStyleNoneData，没有选项
@property (nonatomic, assign) BOOL childAllowsMultipleSelection; // 子选项是否支持多选，默认为NO，最后一排此属性才会生效，YES时展示确认按钮
@property (nonatomic, assign) BOOL allowsReset; // 是否支持重置，支持底部会有重置按钮，默认为NO

@property (nonatomic,   copy) NSString *title; // 标题
@property (nonatomic,   copy) NSDictionary *titleAttributes; // 标题富文本样式，默认字体14，颜色333333
@property (nonatomic,   copy) NSDictionary *selectedTitleAttributes; //标题选中的富文本样式，默认字体14，颜色2684ff
@property (nonatomic,   copy) NSAttributedString *attributedTitle; // 富文本标题，如果设置这个会忽略titleAttributes
@property (nonatomic,   copy) NSAttributedString *selectedAttributedTitle; // 选中的富文本标题，如果设置这个会忽略selectedTitleAttributes
@property (nonatomic, assign) BOOL shouldUseSelectedOptionTitle; // 是否使用选中选项的标题作为标题，默认NO

@property (nonatomic, strong) UIImage *icon; // 箭头图片
@property (nonatomic, strong) UIImage *selectedIcon; // 选中的箭头图片
@property (nonatomic, assign) BOOL shouldIconAutoRotate; // 展示选项列表时，图标是否可以旋转，默认为YES
@property (nonatomic, assign) CGFloat iconTitleSpace; // 标题和箭头的间距，为正在标题右方，为负在标题左方，默认为10

@property (nonatomic, strong) UIColor *separatorLineColor; // 分割线颜色，默认为eeeeee，设置为nil不展示分割线
@property (nonatomic, assign) CGFloat separatorLineIndent; // 分割线缩进，上下间距，默认为10
@property (nonatomic, assign) BOOL showSeparatorAtLast; // 最后一个是否展示分割线，默认NO

@property (nonatomic, assign) BOOL isSelected; // 是否被选中
@property (nonatomic, assign) UITableViewScrollPosition scrollToFirstSelectedOptionPotisionWhenShow; // 展示选项列表的时候自动滚动到第一个选中的选项的位置，默认是UITableViewScrollPositionMiddle，展示在中间

@property (nonatomic, assign) CGFloat optionViewPreferredMaxHeight; // 选项视图的最大高度，默认屏幕高度和底部与父视图对齐的最小值
@property (nonatomic, assign) CGFloat optionViewBottomButtonsPaddintTop; // 选项视图底部按钮距离上面的间隙，默认为0

@property (nonatomic, strong) id extraData; // 额外数据

@end

/**
 分类选项模型的基类，请使用TTCategoryMenuBarListOptionItem或者TTCategoryMenuBarSectionItem
 */
@interface TTCategoryMenuBarOptionItem : NSObject

@property (nonatomic,   copy) NSString *title; // 标题
@property (nonatomic,   copy) NSDictionary *titleAttributes; // 标题富文本样式，默认字体15，颜色333333
@property (nonatomic,   copy) NSDictionary *selectedTitleAttributes; //标题选中的富文本样式，默认字体15，颜色2684ff
@property (nonatomic,   copy) NSAttributedString *attributedTitle; // 富文本标题，如果设置这个会忽略titleAttributes
@property (nonatomic,   copy) NSAttributedString *selectedAttributedTitle; // 选中的富文本标题，如果设置这个会忽略selectedTitleAttributes

@property (nonatomic, strong) UIImage *icon; // 选项图标
@property (nonatomic, strong) UIImage *selectedIcon; // 选中的选项图标
@property (nonatomic, assign) CGFloat iconTitleSpace; // 标题和箭头的间距，为正在标题左方，为负在标题右方，默认为10

@property (nonatomic, strong) UIImage *accessoryIcon; // 右边的附件图标
@property (nonatomic, strong) UIImage *selectedAccessoryIcon; // 右边的附件选中图标

@property (nonatomic, strong) NSArray<__kindof TTCategoryMenuBarOptionItem *> *childOptions; // 子选项列表
@property (nonatomic, assign) BOOL childAllowsMultipleSelection; // 子选项是否支持多选，默认为NO。（分组样式生效，列表样式的最后一排才会生效）

@property (nonatomic, strong, nullable) NSMutableArray<__kindof TTCategoryMenuBarOptionItem *> *selectedChildOptions; // 选中的子选项
@property (nonatomic, assign) BOOL isChildrenAllSelected; // 子选项是否全部选中

@property (nonatomic, strong) id extraData; // 额外数据

@property (nonatomic, weak) TTCategoryMenuBarOptionItem *relatedItem; // 和他是同一个id，但是分布在不同的组里

@end

#pragma mark - 列表式模型

/**
 列表式分类模型，style默认为TTCategoryMenuBarCategoryStyleSingleList
 */
@interface TTCategoryMenuBarListCategoryItem : TTCategoryMenuBarCategoryItem

@property (nonatomic, assign) CGFloat optionListWidthMultiply; // 第一排宽度占总宽度的百分比，单行默认100%，多行默认33.33%
@property (nonatomic, assign) CGFloat optionListWidth; // 第一排选项的宽度，不为0时optionListWidthMultiply无效，默认为0
@property (nonatomic, assign) CGFloat secondOptionListWidthMultiply; //第二排宽度占总宽度的百分比，三排时默认33.33%，两排默认为1-optionListWidthMultiply
@property (nonatomic, assign) CGFloat secondOptionListWidth; // 第二排选项的宽度，不为0时secondOptionListWidthMultiply无效，默认为0

@end

/**
 列表式选项模型
 */
@interface TTCategoryMenuBarListOptionItem : TTCategoryMenuBarOptionItem

@property (nonatomic, strong) UIColor *backgroundColor; // 背景色，默认白色
@property (nonatomic, strong) UIColor *selectBackgroundColor; // 选中的背景色，默认f5f5f5

@property (nonatomic, strong) UIColor *separatorLineColor; // 分割线颜色，默认为eeeeee，设置为nil不展示分割线
@property (nonatomic, assign) CGFloat separatorLineIndent; // 分割线缩进，左右间距，默认为0

@property (nonatomic, assign) CGFloat optionRowHeight; // 单个选项的高度，默认44
@property (nonatomic, assign) CGFloat headIndent; // 头部缩进，默认为0，为0时，文字和图标居中显示
@property (nonatomic, assign) CGFloat tailIndent; // 尾部缩进，默认为15

@property (nonatomic, assign) BOOL isSelectAll; // 是否是全选
@property (nonatomic, assign) BOOL unselectsOthersWhenSelected; // 选中自己时或者自己的子选项全选时是否取消其他选项，默认为NO，只对全选选项有效
@property (nonatomic, assign) BOOL shouldSelectsTitleWhenChildrenAllSelected; // 如果子选项全部选中,父选项是否展示选中的标题，默认为NO
@property (nonatomic, assign) BOOL shouldSelectsTitleWhenSelectsChild; // 当有子标题选中时就,父选项是否展示选中的标题，默认为NO
@property (nonatomic, assign) BOOL isSelected; // 是否被选中

@end

/**
 列表式选项子模型
 */
@interface TTCategoryMenuBarListOptionChildItem : TTCategoryMenuBarListOptionItem

//@property (nonatomic, assign) BOOL isSelectAll; // 是否是全选，选中时选择所有同排选项

@end

#pragma mark - 分组式模型

/**
 分组式分类模型，style为TTCategoryMenuBarCategoryStyleSectionList
 */
@interface TTCategoryMenuBarSectionCategoryItem : TTCategoryMenuBarCategoryItem

@property (nonatomic, strong) UIColor *listBackgroundColor; // 背景色，默认白色
@property (nonatomic, assign) BOOL shouldAlignmentLeft; // 选项内容是否需要居左，默认为NO，居中显示

@end

/**
 分组式每组模型，选中样式不可用
 */
@interface TTCategoryMenuBarSectionItem : TTCategoryMenuBarOptionItem

@property (nonatomic, assign) CGFloat sectionHeaderHeight; // 头部高度，默认40
@property (nonatomic, assign) UIEdgeInsets headerInset; // 头部的缩紧，默认{0, 15, 0 ,15}
@property (nonatomic, assign) UIEdgeInsets sectionInset; // 每组的缩进，默认{0, 15, 0 ,15}

@property (nonatomic, assign) CGFloat lineSpacing; // 每行间隔，默认10
@property (nonatomic, assign) CGFloat interitemSpacing; // 同一行中每个选项的间隔，默认10
@property (nonatomic, assign) CGSize itemSize; // 指定每个选项的大小，默认{0, 0}，默认会自适应大小
@property (nonatomic, assign) UIEdgeInsets itemInset; // 指定每个选项的大小，默认{5, 10, 5, 10}

@property (nonatomic, assign) CGFloat itemCornerRadius; // 每个选项的圆角，默认为3
@property (nonatomic, assign) CGFloat itemBorderWidth; // 边框宽度，默认为0
@property (nonatomic, strong) UIColor *itemBorderColor; // 边框颜色，默认为nil
@property (nonatomic, strong) UIColor *selectedItemBorderColor; // 边框颜色，默认为nil
@property (nonatomic, strong) UIColor *itemBackgroundColor; // 背景色，默认f5f5f5
@property (nonatomic, strong) UIColor *selectItemBackgroundColor; // 选中的背景色，默认f5f5f5

@property (nonatomic, assign) BOOL unselectsOthersWhenSelectAll; // 选中全选时是否取消其他选项，默认为YES
@property (nonatomic, assign) BOOL atLeastOneSelected; // 是否要至少一个被选中，默认NO

@end

/**
 分组式选项模型，子选项不可用，附件icon不可用
 */
@interface TTCategoryMenuBarSectionOptionItem : TTCategoryMenuBarOptionItem

@property (nonatomic, assign) CGSize size; // 指定每个选项的大小，默认为TTCategoryMenuBarSectionItem.itemSize
@property (nonatomic, assign) UIEdgeInsets inset; // 指定每个选项的大小，默认为TTCategoryMenuBarSectionItem.itemInset

@property (nonatomic, assign) CGFloat cornerRadius; // 每个选项的圆角，默认为TTCategoryMenuBarSectionItem.itemCornerRadius
@property (nonatomic, assign) CGFloat borderWidth; // 边框宽度，默认为TTCategoryMenuBarSectionItem.itemBorderWidth
@property (nonatomic, strong) UIColor *borderColor; // 边框颜色，默认为TTCategoryMenuBarSectionItem.itemBorderColor
@property (nonatomic, strong) UIColor *selectedBorderColor; // 选中的边框颜色，默认为TTCategoryMenuBarSectionItem.selectedItemBorderColor

@property (nonatomic, strong) UIColor *backgroundColor; // 背景色，默认为TTCategoryMenuBarSectionItem.itemBackgroundColor
@property (nonatomic, strong) UIColor *selectBackgroundColor; // 选中的背景色，默认为TTCategoryMenuBarSectionItem.selectItemBackgroundColor

@property (nonatomic, assign) BOOL isSelected; // 是否被选中
@property (nonatomic, assign) BOOL isSelectAll; // 是否是全选

@property (nonatomic, assign) BOOL enabled; // Item是否可点击，默认YES

@end


NS_ASSUME_NONNULL_END
