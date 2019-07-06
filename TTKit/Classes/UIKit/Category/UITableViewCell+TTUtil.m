//
//  UITableViewCell+TTUtil.m
//  TTKit
//
//  Created by rollingstoneW on 2019/6/25.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "UITableViewCell+TTUtil.h"
#import <objc/runtime.h>

@implementation UITableViewCell (TTUtil)

- (UITableView *)tt_tableView {
    UITableView *tableView = objc_getAssociatedObject(self, _cmd);
    if (!tableView) {
        UIView *superview = self.superview;
        while (![superview isKindOfClass:[UITableView class]] && superview) {
            superview = self.superview;
        }
        self.tt_tableView = tableView = (UITableView *)superview;
    }
    return tableView;
}

- (void)setTt_tableView:(UITableView *)tableView {
    objc_setAssociatedObject(self, @selector(tt_tableView), tableView, OBJC_ASSOCIATION_ASSIGN);
}

+ (NSString *)tt_defaultIdentifier {
    NSString *defaultIdentifier = objc_getAssociatedObject(self, _cmd);
    if (!defaultIdentifier) {
        defaultIdentifier = NSStringFromClass(self);
        objc_setAssociatedObject(self, _cmd, defaultIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return defaultIdentifier;
}

+ (void)tt_registInTableView:(UITableView *)tableView {
    [tableView registerClass:self forCellReuseIdentifier:self.tt_defaultIdentifier];
}

+ (instancetype)tt_reusableCellInTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.tt_defaultIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.tt_defaultIdentifier];
    }
    cell.tt_tableView = tableView;
    return cell;
}

@end
