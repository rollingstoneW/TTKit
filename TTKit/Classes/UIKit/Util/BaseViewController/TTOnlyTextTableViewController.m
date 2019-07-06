//
//  TTOnlyTextTableViewController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/27.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTOnlyTextTableViewController.h"
#import "TTKit.h"

@interface TTOnlyTextTableViewController ()

@end

@implementation TTOnlyTextTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isMultiSection]) {
        return self.dataArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cellsAtSection:section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self headerTitleAtSection:section]) {
        return 40;
    }
    return CGFLOAT_MIN;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self headerTitleAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell tt_reusableCellInTableView:tableView];
    cell.textLabel.text = [self cellTitleAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL sel = NSSelectorFromString([self cellSELAtIndexPath:indexPath]);
    if ([self respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning([self performSelector:sel];)
    }
}

- (NSString *)headerTitleAtSection:(NSInteger)section {
    if (![self isMultiSection]) {
        return nil;
    }
    NSDictionary *sectionInfo = (NSDictionary *)self.dataArray[section];
    if ([sectionInfo isKindOfClass:[NSDictionary class]]) {
        return sectionInfo[TTTableViewHeaderTitleKey];
    }
    return nil;
}

- (NSString *)cellTitleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cells = [self cellsAtSection:indexPath.section];
    id item = cells[indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]]) {
        return item[TTTableViewCellTitleKey];
    }
    return item;
}

- (NSString *)cellSELAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cells = [self cellsAtSection:indexPath.section];
    id item = cells[indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]]) {
        return item[TTTableViewCellSELKey];
    }
    if ([self isMultiSection]) {
        return [NSString stringWithFormat:@"sel%zd_%zd", indexPath.section, indexPath.row];
    }
    return [NSString stringWithFormat:@"sel%zd", indexPath.row];
}

- (NSArray *)cellsAtSection:(NSInteger)section {
    if (![self isMultiSection]) {
        return self.dataArray;
    }
    NSDictionary *sectionInfo = (NSDictionary *)self.dataArray[section];
    if ([sectionInfo isKindOfClass:[NSArray class]]) {
        return (NSArray *)sectionInfo;
    }
    return sectionInfo[TTTableViewCellsKey];
}

- (BOOL)isMultiSection {
    if ([self.dataArray.firstObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *sectionInfo = (NSDictionary *)self.dataArray.firstObject;
        if ([sectionInfo.allKeys containsObject:TTTableViewCellsKey] ) {
            return YES;
        }
    }
    if ([self.dataArray.firstObject isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

@end
