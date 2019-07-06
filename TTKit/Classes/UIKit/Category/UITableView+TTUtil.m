//
//  UITableView+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/14.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UITableView+TTUtil.h"

@implementation UITableView (TTUtil)

- (NSInteger)tt_numberOfRowsInTotal {
    NSInteger number = 0;
    for (NSInteger i = 0, numberOfSections = self.numberOfSections; i < numberOfSections; i++) {
        number += [self numberOfRowsInSection:i];
    }
    return number;
}

- (NSIndexPath *)tt_lastIndexPath {
    NSInteger numberOfSections = self.numberOfSections;
    if (!numberOfSections) { return nil; }
    NSInteger numberOfRows = [self numberOfRowsInSection:numberOfSections - 1];
    if (!numberOfRows) { return nil; }

    return [NSIndexPath indexPathForRow:numberOfRows - 1 inSection:numberOfSections - 1];
}

- (void)tt_scrollToLastRowAtBottomAnimated:(BOOL)animated {
    [self scrollToRowAtIndexPath:[self tt_lastIndexPath] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)tt_reloadByPrependingRowsWithoutVisibleAreaChange {
    [self tt_reloadByPrependingRowsWithoutVisibleAreaChangeAtSection:0];
}

- (void)tt_reloadByPrependingRowsWithoutVisibleAreaChangeAtSection:(NSInteger)section {
    NSInteger originNumber = [self numberOfRowsInSection:section];
    [self reloadData];
    NSInteger currentNumber = [self numberOfRowsInSection:0];
    NSInteger newNumber = currentNumber - originNumber;
    newNumber = MIN(newNumber, currentNumber - 1);
    if (newNumber <= 0) {
        return;
    }
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newNumber inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

@end
