//
//  TTViewController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTViewController.h"
//#import "TTNetworkTask.h"
#import "TTUIKitFactory.h"
#import "MJRefresh.h"

@interface TTPulldownToGobackHeader : MJRefreshStateHeader
@end
@implementation TTPulldownToGobackHeader

- (void)prepare {
    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;

    [self setTitle:@"下拉关闭页面" forState:MJRefreshStateIdle];
    [self setTitle:@"松手关闭页面" forState:MJRefreshStatePulling];
    [self setTitle:@"松手关闭页面" forState:MJRefreshStateRefreshing];
}

@end

@interface TTViewController () <UIGestureRecognizerDelegate>

@end

@implementation TTViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.autoCancelNetworkTasksBeforeDealloc = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self loadCustomNavigationBar];
    [self loadSubviews];

    [self setupDefaultBackBarItem];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_orientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.hidesBackButton = self.hidesBackButton;
    [self.navigationController setNavigationBarHidden:self.tt_prefersNavigationBarHidden animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.hasAppeared = YES;
    });
    self.isWholeAppeared = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = !self.disablesSwipeBackGesture;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isWholeAppeared = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (!self.parentViewController && [self autoCancelNetworkTasksBeforeDealloc]) {
//        [self cancelNetworkTasks];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.customNavigationBar) {
        [self.view bringSubviewToFront:self.customNavigationBar];
    }
}

- (void)dealloc {
    NSLog(@"\n----------------\ndealloced: %@ title = %@\n----------------", self, self.title);
}

+ (id<TTViewControllerRouter>)routerWithDictionary:(NSDictionary *)params {
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)params {
    return [super init];
}

- (void)loadSubviews {}

- (void)loadCustomNavigationBar {}

- (__kindof UIView *)showingNavigationBar {
    if (self.customNavigationBar && !self.customNavigationBar.hidden) {
        return self.customNavigationBar;
    }
    if (self.tt_prefersNavigationBarHidden || self.navigationController.navigationBarHidden) {
        return nil;
    }
    return self.navigationController.navigationBar;
}

- (CGFloat)navigationBarHeight {
    if (self.customNavigationBar && !self.customNavigationBar.hidden) {
        return CGRectGetMaxY(self.customNavigationBar.frame);
    }
    if (self.tt_prefersNavigationBarHidden || self.navigationController.navigationBarHidden) {
        return 0;
    }
    return CGRectGetMaxY(self.navigationController.navigationBar.frame);
}

- (UIEdgeInsets)subviewInsets {
    return UIEdgeInsetsMake([self navigationBarHeight], 0, 0, 0);
}

- (BOOL)prefersStatusBarHidden {
    return self.tt_prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.tt_prefersStatusBarStyle;
}

- (void)touchStatusBar {}
- (void)reloadData {}
- (void)_orientationDidChange:(NSNotification *)noti {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self statusBarOrientationDidChange:orientation];
}

- (void)statusBarOrientationDidChange:(UIInterfaceOrientation)orientation {}

- (void)setupDefaultBackBarItem {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)setupDefaultLeftCloseBarItem {
    [self addLeftBarItemWithTitle:@"取消" image:nil selector:@selector(goback)];
}

- (void)setupDefaultRightCloseBarItem {
    [self addRightBarItemWithTitle:@"取消" image:nil selector:@selector(goback)];
}

- (UIView *)addPulldownToGobackHeaderInScrollView:(UIScrollView *)scrollView {
    if (!scrollView) { return nil; }
    scrollView.mj_header = [TTPulldownToGobackHeader headerWithRefreshingTarget:self refreshingAction:@selector(goback)];
    return scrollView.mj_header;
}

@end
