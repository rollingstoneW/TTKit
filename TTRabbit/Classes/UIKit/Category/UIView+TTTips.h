//
//  UIView+Loading.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/20.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TTTips)


/**
 展示空数据提示占位图

 @param block 点击占位图的回掉
 */
- (__kindof UIView *)tt_showEmptyTipViewWithTapedBlock:(dispatch_block_t)block;

/**
 展示网络请求错误的占位图

 @param block 点击占位图的回掉
 */
- (__kindof UIView *)tt_showNetErrorTipViewWithTapedBlock:(dispatch_block_t)block;

/**
 自定义占位图

 @param title 提示内容，NSString或者NSAttributedString
 @param image 图片
 @param block 点击占位图的回掉
 */
- (__kindof UIView *)tt_showTipViewWithTitle:(id)title image:(UIImage *)image tapedBlock:(dispatch_block_t)block;

/**
 自定义占位图

 @param customView 自定义展示内容
 @param block 点击占位图的回掉
 */
- (__kindof UIView *)tt_showTipViewWithCustomView:(UIView *)customView tapedBlock:(dispatch_block_t)block;

@end
