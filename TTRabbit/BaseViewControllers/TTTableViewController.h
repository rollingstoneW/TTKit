//
//  TTTableViewController.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTViewController.h"

FOUNDATION_EXTERN NSInteger const TTDefaultPageSize;

@interface TTTableViewController : TTViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 页码是否从0开始，默认为YES
 */
@property (nonatomic, assign) BOOL isPageNumberStartAtZero;

/**
 当前页码，isPageNumberStartAtZero YES时默认为0，NO时默认为1
 */
@property (nonatomic, assign) NSInteger currentPage;

/**
 当前最后一条数据的id
 */
@property (nonatomic,   copy) NSString *currentId;

/**
 每页数据最大个数
 */
@property (nonatomic, assign) NSInteger pageSize;

/**
 是否禁用groupedStyle自动适应section header和footer高度，默认YES
 */
@property (nonatomic, assign) BOOL disableGroupSectionHeaderFooterAutomaticDimension;

- (instancetype)initWithStyle:(UITableViewStyle)style;

/**
 重写这个方法自定义tableView
 */
- (void)loadTableView;

/**
 默认下拉刷新方法
 */
- (void)loadNewData;

/**
 默认上拉加载方法
 */
- (void)loadMoreData;

/**
 设置refreshHeader refreshFooter
 */
- (void)setupRefreshActions;
/**
 设置refreshHeader refreshFooter，方法为空则不设置
 */
- (void)setupRefreshWithActionForHeader:(SEL)headerSEL footer:(SEL)footerSEL;

/**
 设置刷新的header
*/
- (void)setupRefreshHeaderWithBlock:(dispatch_block_t)block;

/**
 设置刷新的footer
*/
- (void)setupRefreshFooterWithBlock:(dispatch_block_t)block;

/**
 触发下拉刷新的方法
 */
- (void)triggerHeaderRefresh;

/**
 触发上拉加载更多的方法
 */
- (void)triggerFooterRefresh;

/**
 自动设置footer的隐藏和展示
 */
- (void)autoHideFooterWithNewData:(NSArray *)list;
- (void)autoHideFooterWithHasMoreData:(BOOL)hasMoreData;

@end
