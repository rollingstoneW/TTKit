//
//  TTViewController.h
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTViewControllerRouter.h"
#import "UIViewController+TTUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTViewController : UIViewController

@property (nonatomic, assign) BOOL hasAppeared; // 是否已经展示过
@property (nonatomic, assign) BOOL isWholeAppeared; // 是否是完全展示
@property (nonatomic, assign) BOOL disablesSwipeBackGesture; // 禁用滑动返回
@property (nonatomic, assign) BOOL needsLogin; // 是否需要登录(未实现)
@property (nonatomic, assign) BOOL hidesBackButton; // 是否隐藏返回按钮
@property (nonatomic, assign) BOOL shouldCancelNetworkTasksWhenDismissed; // 消失后是否自动取消网络请求, YES

@property (nonatomic, assign) BOOL tt_prefersStatusBarHidden; // 状态栏隐藏
@property (nonatomic, assign) UIStatusBarStyle tt_prefersStatusBarStyle; // 状态栏样式

@property (nonatomic, assign) BOOL tt_prefersNavigationBarHidden; // 导航栏隐藏
@property (nonatomic, strong) UIView *customNavigationBar; // 自定义导航栏

// 子类实现，处理router
+ (id<TTViewControllerRouter>)routerWithDictionary:(NSDictionary *)params;
- (instancetype)initWithDictionary:(NSDictionary *)params;

- (void)loadCustomNavigationBar; // 加载自定义导航栏
- (void)loadSubviews; // 加载子视图
- (__kindof UIView *)showingNavigationBar; // 当前展示的导航栏，系统导航栏或者自定义导航栏
- (CGFloat)navigationBarHeight; // 导航栏高度
- (UIEdgeInsets)subviewInsets; // 子视图缩进

// 子类实现
- (void)touchStatusBar; // 触摸状态栏
- (void)reloadData; // 重新加载数据
- (void)statusBarOrientationDidChange:(UIInterfaceOrientation)orientation; // 界面发生旋转

- (void)goback; // 返回到上一级页面，内部会判断是pop还是dismiss

- (void)setupDefaultLeftCloseBarItem; // 设置默认关闭按钮
- (void)setupDefaultRightCloseBarItem; // 设置默认关闭按钮

// 如果视图中有scrollView，给scrollView添加下拉关闭页面的header
- (UIView *)addPulldownToGobackHeaderInScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
