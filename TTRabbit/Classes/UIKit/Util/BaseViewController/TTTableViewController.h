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

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic,   copy) NSString *currentId;
@property (nonatomic, assign) NSInteger pageSize;

/**
 是否禁用groupedStyle自动适应section header和footer高度，默认YES
 */
@property (nonatomic, assign) BOOL disableGroupSectionHeaderFooterAutomaticDimension;

- (instancetype)initWithStyle:(UITableViewStyle)style;

// 重写这个方法自定义tableView
- (void)loadTableView;

// 默认下拉刷新方法
- (void)loadNewData;
// 默认上拉加载方法
- (void)loadMoreData;

// 设置refreshHeader refreshFooter
- (void)setupRefreshActions;
- (void)setupRefreshWithActionForHeader:(SEL)headerSEL footer:(SEL)footerSEL;

// 自动下拉
- (void)triggerHeaderRefresh;
// 自动上拉
- (void)triggerFooterRefresh;

// 自动设置footer的隐藏和展示
- (void)autoHideFooterWithNewData:(NSArray *)list;

@end
