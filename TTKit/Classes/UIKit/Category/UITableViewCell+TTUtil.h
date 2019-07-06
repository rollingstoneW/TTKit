//
//  UITableViewCell+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/6/25.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (TTUtil)

/**
 如果没有设置次属性，会遍历父视图寻找
 */
@property (nonatomic, weak) UITableView *tt_tableView;

/**
 默认identifier
 */
@property (nonatomic, class, readonly) NSString *tt_defaultIdentifier;

// 注册
+ (void)tt_registInTableView:(UITableView *)tableView;
// 复用
+ (instancetype)tt_reusableCellInTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
