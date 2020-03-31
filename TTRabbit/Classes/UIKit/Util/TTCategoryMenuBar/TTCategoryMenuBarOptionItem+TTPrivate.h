//
//  TTCategoryMenuBarOptionItem+TTPrivate.h
//  TTRabbit
//
//  Created by 滚石 on 2020/3/28.
//

#import <TTRabbit/TTCategoryMenuItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCategoryMenuBarOptionItem (TTPrivate)

// 是否有子选项选中了
- (BOOL)hasSelectedChild;

// 是否被选中了
- (BOOL)isSelfSelected;

// 加载selectedChildOptions，在TTCategoryMenuBarOptionView外部调用此方法，后面一定要调用clearSelectedChildren
- (BOOL)loadSelectedChild;

// 清理selectedChildOptions
- (void)clearSelectedChildren;

// 重置
- (void)reset;
- (void)resetFrom:(TTCategoryMenuBarOptionItem *)item;

@end

NS_ASSUME_NONNULL_END
