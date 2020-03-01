//
//  UIViewController+TTUtil.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/20.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTAlertHandler)(NSInteger index);

@interface UIViewController (TTUtil)

/**
 设置富文本标题
 */
@property (nonatomic, copy) NSAttributedString *tt_attributedTitle;

/**
 获取当前显示的控制器
 */
+ (UIViewController *)tt_currentViewController;

/**
 获取自身下面的页面，可能是导航栈的上一个页面，或者presentingViewController
*/
- (UIViewController *)tt_belowViewController;

/**
 返回到上个页面，自动pop或者dismiss
 */
- (void)tt_goback;

/**
 返回到window的根控制器
 */
- (void)tt_gobackToRoot;

/**
 将要从添加到视图层级
 */
- (BOOL)tt_isMovingToViewHierarchy;

/**
 将要从视图层级中移除
 */
- (BOOL)tt_isMovingFromViewHierarchy;

/**
 添加下滑返回的手势
 */
- (void)tt_addSwipeDownGestureToDismiss;

/**
 右滑返回时禁用scrollView滚动手势
 */
- (void)tt_disablesScrollViewScrollWhileSwipeBack:(UIScrollView *)scrollView;

/**
 禁用UIScrollView自动调整contentInset
 */
- (void)tt_disablesScrollViewAutoAdjustContentInset:(UIScrollView *)scrollView;

/**
 添加navigationBar上左边的按钮功能
 */
- (void)tt_addRightBarItemWithTitle:(NSString * _Nullable)title image:(UIImage * _Nullable)image selector:(SEL)selecor;
- (void)tt_addRightBarItemWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color selector:(SEL)selecor;

/**
 添加navigationBar上右边的按钮功能
 */
- (void)tt_addLeftBarItemWithTitle:(NSString * _Nullable)title image:(UIImage * _Nullable)image selector:(SEL)selecor;

/**
 向自身下面的页面发送消息

 @param message 消息
 @param object 对象
 @param userInfo 自定义消息
 @return 结果
*/
- (id _Nullable)tt_postMessageToBelow:(NSString *)message
                               object:(id _Nullable)object
                             userInfo:(NSDictionary * _Nullable)userInfo;

#pragma mark - Alert

/**
 展示只有确定按钮的系统弹窗
 
 @param title 标题
 @param message 信息
 @param handler 点击确定的回掉
 @return 弹窗
 */
- (UIAlertController *)tt_showOKAlertWithTitle:(NSString *)title message:(NSString *)message handler:(dispatch_block_t _Nullable)handler;

/**
 展示有取消和确定按钮的系统弹窗
 
 @param title 标题
 @param message 信息
 @param handler 点击按钮的回掉。index为0是取消，1是确定
 @return 弹窗
 */
- (UIAlertController *)tt_showCancelableAlertWithTitle:(NSString *)title message:(NSString *)message handler:(TTAlertHandler)handler;

/**
 展示只有确定按钮的系统弹窗
 
 @param title 标题
 @param message 信息
 @param cancelTitle 取消按钮的标题
 @param OKTitle 确定按钮的标题
 @param handler 点击按钮的回掉。index为0是取消，1是确定
 @return 弹窗
 */
- (UIAlertController *)tt_showCancelableAlertWithTitle:(NSString *)title
                                               message:(NSString *)message
                                           cancelTitle:(NSString *)cancelTitle
                                               OKTitle:(NSString *)OKTitle
                                               handler:(TTAlertHandler)handler;

/**
 展示系统列表选择器
 
 @param title 标题
 @param message 信息
 @param actions 选择的title列表
 @param handler 点击按钮的回掉。index为-1是取消，其余对应在actions中的index
 @return 弹窗
 */
- (UIAlertController *)tt_showActionSheetWithTitle:(NSString *)title
                                           message:(NSString *)message
                                           actions:(NSArray *)actions
                                           handler:(TTAlertHandler)handler;

#pragma mark - Loading

/**
 展示loading加载指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)tt_showLoadingToast:(NSString *)toast;
- (__kindof UIView *)tt_showLoadingToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示错误指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)tt_showErrorToast:(NSString *)toast;
- (__kindof UIView *)tt_showErrorToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示成功指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)tt_showSuccessToast:(NSString *)toast;
- (__kindof UIView *)tt_showSuccessToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示警告指示窗
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)tt_showWarningToast:(NSString *)toast;
- (__kindof UIView *)tt_showWarningToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;

/**
 展示文字提示
 @param toast 文字内容，hideAfterDelay几秒后自动消失
 */
- (__kindof UIView *)tt_showTextToast:(NSString *)toast;
- (__kindof UIView *)tt_showTextToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
- (void)tt_hideToasts;

#pragma mark - Tip

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
