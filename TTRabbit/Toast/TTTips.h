//
//  TTTips.h
//  TTRabbit
//
//  Created by Rabbit on 2020/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
- (__kindof UIView *)tt_showTipViewWithTitle:(id _Nullable)title image:(UIImage * _Nullable)image tapedBlock:(dispatch_block_t)block;

/**
 自定义占位图

 @param customView 自定义展示内容
 @param block 点击占位图的回掉
 */
- (__kindof UIView *)tt_showTipViewWithCustomView:(UIView *)customView tapedBlock:(dispatch_block_t)block;

@end

@interface UIViewController (TTTips)

/**
 展示空页面指示视图
 @param block 点击的回掉
 */
- (__kindof UIView *)tt_showEmptyTipViewWithTapedBlock:(dispatch_block_t)block;

/**
 展示网络错误指示视图
 @param block 点击的回掉
 */
- (__kindof UIView *)tt_showNetErrorTipViewWithTapedBlock:(dispatch_block_t)block;

/**
 展示自定义指示视图
 @param title 标题，NSString或者NSAtrributedString
 @param image 图片
 @param block 点击的回掉
 */
- (__kindof UIView *)tt_showTipViewWithTitle:(id)title image:(UIImage *)image tapedBlock:(dispatch_block_t)block;

/**
 展示自定义指示视图
 @param customView 自定义展示内容
 @param block 点击占位图的回掉
 */
- (__kindof UIView *)tt_showTipViewWithCustomView:(UIView *)customView tapedBlock:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
