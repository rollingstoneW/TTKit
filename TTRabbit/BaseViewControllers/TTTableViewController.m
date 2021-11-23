//
//  TTTableViewController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "TTMacros.h"

NSInteger const TTDefaultPageSize = 20;

@interface TTTableViewController ()

@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, strong) dispatch_block_t refreshHeaderBlock;
@property (nonatomic, strong) dispatch_block_t refreshFooterBlock;

@end

@implementation TTTableViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        _isPageNumberStartAtZero = YES;
        _currentPage = 0;
        _pageSize = TTDefaultPageSize;
        _currentId = nil;
        _style = style;
        _disableGroupSectionHeaderFooterAutomaticDimension = YES;
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = UIEdgeInsetsInsetRect(self.view.bounds, [self subviewInsets]);
}

- (void)loadSubviews {
    [super loadSubviews];
    [self loadTableView];
}

- (void)loadTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = [UIView new];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_15_0//新增属性版本判断，适配xcode13以下版本
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
#endif
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)loadNewData {
    self.currentPage = 0;
    self.currentId = nil;
}
- (void)loadMoreData {
    self.currentPage ++;
}

- (void)setupRefreshActions {
    [self setupRefreshWithActionForHeader:@selector(loadNewData) footer:@selector(loadMoreData)];
}

- (void)setupRefreshWithActionForHeader:(SEL)headerSEL footer:(SEL)footerSEL {
    if (headerSEL && [self respondsToSelector:headerSEL]) {
        self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:headerSEL];;
    }
    if (footerSEL && [self respondsToSelector:footerSEL]) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:footerSEL];
    }
}

- (void)setupRefreshHeaderWithBlock:(dispatch_block_t)block {
    self.refreshHeaderBlock = block;
    [self setupRefreshWithActionForHeader:@selector(_headerRefresh) footer:NULL];
}

- (void)setupRefreshFooterWithBlock:(dispatch_block_t)block {
    self.refreshFooterBlock = block;
    [self setupRefreshWithActionForHeader:NULL footer:@selector(_footerRefresh)];
}

- (void)_headerRefresh {
    TTSafeBlock(self.refreshHeaderBlock);
}

- (void)_footerRefresh {
    TTSafeBlock(self.refreshFooterBlock);
}

- (void)triggerHeaderRefresh {
    if ([self.tableView.mj_header isRefreshing]) {
        return;
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)triggerFooterRefresh {
    if ([self.tableView.mj_footer isRefreshing]) {
        return;
    }
    [self.tableView.mj_footer beginRefreshing];
}

- (void)autoHideFooterWithNewData:(NSArray *)list {
    [self autoHideFooterWithHasMoreData:list.count == self.pageSize];
}

- (void)autoHideFooterWithHasMoreData:(BOOL)hasMoreData {
    if (hasMoreData) {
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    } else {
        if (self.currentPage == (self.isPageNumberStartAtZero ? 0 : 1)) {
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(tableView:titleForHeaderInSection:)] && [self tableView:tableView titleForHeaderInSection:section]) {
        return nil;
    }
    if (tableView.style == UITableViewStyleGrouped && self.disableGroupSectionHeaderFooterAutomaticDimension) {
        return [UIView new];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView.style == UITableViewStyleGrouped && self.disableGroupSectionHeaderFooterAutomaticDimension) {
        return [UIView new];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.style == UITableViewStyleGrouped && self.disableGroupSectionHeaderFooterAutomaticDimension) {
        return CGFLOAT_MIN;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.style == UITableViewStyleGrouped && self.disableGroupSectionHeaderFooterAutomaticDimension) {
        return CGFLOAT_MIN;
    }
    return 0;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setIsPageNumberStartAtZero:(BOOL)isPageNumberStartAtZero {
    _isPageNumberStartAtZero = isPageNumberStartAtZero;
    self.currentPage = isPageNumberStartAtZero ? 0 : 1;
}

@end
