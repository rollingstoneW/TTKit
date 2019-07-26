//
//  TTCategoryMenuBarOptionView.h
//  TTKit
//
//  Created by rollingstoneW on 2019/7/1.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTCategoryMenuItem.h"
@class TTCategoryMenuBarOptionView, TTCategoryMenuBarSectionListView;

NS_ASSUME_NONNULL_BEGIN

@protocol TTCategoryMenuBarOptionViewDelegate <NSObject>

@optional

/**
 列表提交了数据
 */
- (void)categoryBarOptionView:(TTCategoryMenuBarOptionView *)optionView didCommitOptions:(NSArray<TTCategoryMenuBarOptionItem *> *)options;

/**
 列表重置了数据
 */
- (void)categoryBarOptionViewDidResetOptions:(TTCategoryMenuBarOptionView *)optionView;

/**
 选中的数据发生了变化
 @param selectedOptions 选中的数据数组
 */
- (void)categoryBarOptionView:(TTCategoryMenuBarOptionView *)optionView selectedOptionsDidChange:(NSArray *)selectedOptions;

@end

@protocol TTCategoryMenuBarSectionListDataSource <NSObject>

/**
 自定义选项样式，返回nil则使用默认样式
 */
- (UICollectionViewCell *)sectionList:(TTCategoryMenuBarSectionListView *)sectionList cellForItem:(TTCategoryMenuBarSectionOptionItem *)item;

@end


/**
 基类，请使用子类，必须实现sizeThatFits返回合适的大小
 */
@interface TTCategoryMenuBarOptionView : UIView

- (instancetype)initWithCategory:(__kindof TTCategoryMenuBarCategoryItem *)category options:(NSArray<__kindof TTCategoryMenuBarOptionItem *> *)options;

@property (nonatomic, strong) __kindof TTCategoryMenuBarCategoryItem *categoryItem; // 分类模型
@property (nonatomic, strong) NSArray<__kindof TTCategoryMenuBarOptionItem *> *options; // 列表模型数组
@property (nonatomic, strong, readonly) NSArray *selectedOptions; // 选中的模型数组

@property (nonatomic,   weak) id<TTCategoryMenuBarOptionViewDelegate> delegate;

@property (nonatomic, strong) UIButton *doneButton; // 完成按钮
@property (nonatomic, strong) UIButton *resetButton; // 重置按钮

- (void)reloadData; // 刷新
- (UIButton *)loadDoneButton; // 加载完成按钮，子类可自定义
- (UIButton *)loadResetButton; // 加载重置按钮，子类可自定义

/**
 清除选中的子选项数据，需要在列表消失后手动调用
 */
- (void)clearSelectedOptions;

@end

/**
 单列选项列表
 */
@interface TTCategoryMenuBarSingleListOptionView : TTCategoryMenuBarOptionView
@property (nonatomic, strong) UITableView *tableView;
@end

/**
 双列选项列表
 */
@interface TTCategoryMenuBarDoubleListOptionView : TTCategoryMenuBarOptionView
@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;
@end

/**
 三列选项列表
 */
@interface TTCategoryMenuBarTripleListOptionView : TTCategoryMenuBarOptionView
@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, strong) UITableView *thirdTableView;
@end

/**
 多列分组式列表
 */
@interface TTCategoryMenuBarSectionListView : TTCategoryMenuBarOptionView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<TTCategoryMenuBarSectionListDataSource> dataSource;
@end

NS_ASSUME_NONNULL_END
