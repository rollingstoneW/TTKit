//
//  UITableView+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/14.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (TTUtil)

/**
 cell总数量
 */
- (NSInteger)tt_numberOfRowsInTotal;

/**
 最后一个cell的indexPath
 */
- (NSIndexPath *)tt_lastIndexPath;

/**
 在section里最后一个cell的indexPath
 
 @param section 在哪个section
 */
- (NSIndexPath *)tt_lastIndexPathInSection:(NSUInteger)section;

/**
 让最后一个cell滚动到最底部

 @param animated 是否需要动画
 */
- (void)tt_scrollToLastRowAtBottomAnimated:(BOOL)animated;

/**
 在列表最前面插入一批cell，保持列表可见的cell位置不变，常见于消息列表下拉加载后，当前消息位置不变。需要先更新数据源再执行本方法
 */
- (void)tt_reloadByPrependingRowsWithoutVisibleAreaChange;
- (void)tt_reloadByPrependingRowsWithoutVisibleAreaChangeAtSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
