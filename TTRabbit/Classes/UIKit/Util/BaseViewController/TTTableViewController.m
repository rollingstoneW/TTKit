//
//  TTTableViewController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/22.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTTableViewController.h"
#import "MJRefresh.h"
#import "TTMacros.h"

NSInteger const TTDefaultPageSize = 20;

@interface TTTableViewController ()

@property (nonatomic, assign) UITableViewStyle style;

@end

@implementation TTTableViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
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
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:footerSEL];
    }
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
    if (list.count == self.pageSize) {
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    } else {
        if (self.currentPage == 0) {
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

kGetterObjectIMP(dataArray, [NSMutableArray array]);

@end
