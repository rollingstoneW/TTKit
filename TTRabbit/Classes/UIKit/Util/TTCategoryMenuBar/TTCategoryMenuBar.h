//
//  TTCategoryMenuBar.h
//  TTKit
//
//  Created by rollingstoneW on 2019/7/1.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTCategoryMenuItem.h"
@class TTCategoryMenuBar, TTCategoryMenuBarOptionView;

NS_ASSUME_NONNULL_BEGIN

@protocol TTCategoryMenuBarDelegate <NSObject>

@optional

/**
 选中了某个分类
 */
- (void)categoryMenuBar:(TTCategoryMenuBar *)menuBar didSelectCategory:(NSInteger)category;

/**
 取消选中了某个分类，只有分类类型为NoneData才会回掉
 */
- (void)categoryMenuBar:(TTCategoryMenuBar *)menuBar didDeSelectCategory:(NSInteger)category;

/**
 将要展示选项列表
 */
- (void)categoryMenuBar:(TTCategoryMenuBar *)menuBar willShowOptionView:(TTCategoryMenuBarOptionView *)optionView atCategory:(NSInteger)category;

/**
 提交了某个分类的数据，非单排分类
 */
- (void)categoryMenuBar:(TTCategoryMenuBar *)menuBar didCommitCategoryOptions:(NSArray<TTCategoryMenuBarOptionItem *> *)options atCategory:(NSInteger)category;

/**
 重置了某个分类的数据，非单排分类
 */
- (void)categoryMenuBar:(TTCategoryMenuBar *)menuBar didResetCategory:(NSInteger)category;

/**
 自定义选项列表，分类stlye为TTCategoryMenuBarCategoryStyleCustom会调用
 */
- (__kindof TTCategoryMenuBarOptionView *)categoryMenuBar:(TTCategoryMenuBar *)menuBar optionViewAtIndex:(NSInteger)index;

/**
 可以配置按钮的样式
 */
- (void)categoryMenuBar:(TTCategoryMenuBar *)menuBar configButtonItem:(UIButton *)item atCategory:(NSInteger)category;

/**
 选项列表选中的数据发生了变化
 @param selectedOptions 选中的数据数组
 */
- (void)categoryMenuBar:(TTCategoryMenuBar *)menuBar optionView:(TTCategoryMenuBarOptionView *)optionView selectedOptionsDidChange:(NSArray *)selectedOptions;

/**
 为选项列表选中的内容设置分类的标题，可以是NSString、NSAttributedString
@param options 选中的数据数组
*/
- (id _Nullable)categoryMenuBar:(TTCategoryMenuBar *)menuBar titleForSelectedOptions:(NSArray<TTCategoryMenuBarOptionItem *> *)options atCategory:(NSInteger)category;

@end


@interface TTCategoryMenuBar : UIView

/**
 分类模型
 */
@property (nonatomic,   copy) NSArray<__kindof TTCategoryMenuBarCategoryItem *> *items;

/**
 分类对应的选项模型，最多支持三层
 */
@property (nonatomic,   copy) NSArray<NSArray<__kindof TTCategoryMenuBarOptionItem *> *> *options;

/**
 代理
 */
@property (nonatomic,   weak) id<TTCategoryMenuBarDelegate> delegate;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

/**
 展示时蒙层的半透明背景色，默认为黑色，透明度0.6
 */
@property (nonatomic, strong) UIColor *dimBackgroundColor;

/**
 分类按钮在bar里的缩进，默认不缩进
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 统一初始化方法

 @param items 分类模型
 @param options 分类对应的选项模型
 */
- (instancetype)initWithItems:(NSArray<__kindof TTCategoryMenuBarCategoryItem *> *)items
                      options:(NSArray<NSArray<__kindof TTCategoryMenuBarOptionItem *> *> *)options;

/**
 刷新分类
 */
- (void)reloadItems:(NSArray<__kindof TTCategoryMenuBarCategoryItem *> *)items
            options:(NSArray<NSArray<__kindof TTCategoryMenuBarOptionItem *> *> *)options;

/**
 刷新某个分类的item
*/
- (void)updateItem:(__kindof TTCategoryMenuBarCategoryItem *)item atCategory:(NSInteger)category;

/**
 展示某个分类
*/
- (void)showOptionViewAtCategory:(NSInteger)category;

/**
 隐藏当前展示的分类
*/
- (void)dismissCurrentOptionView;

/**
 获取某个分类的按钮
 */
- (UIButton *)menuButtonItemAtCategory:(NSInteger)category;

/**
 旋转分类按钮
 */
- (void)rotateItemIcon:(UIButton *)button;

/**
 使分类按钮回正
 */
- (void)resetItemIcon:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
