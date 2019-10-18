//
//  TTViewController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

#import "TTViewController.h"
#import "TTUIKitFactory.h"
#import "UIView+TTUtil.h"
#import "TTPulldownDismissHeader.h"
#import "TTNavigationControllerChildProtocol.h"

#if __has_include("TTNetworkCancellable.h")
#import "TTNetworkCancellable.h"
#endif

NSString *const TTViewControllerDidDismissNotification = @"TTViewControllerDidDismissNotification";

@interface TTViewController () <UIGestureRecognizerDelegate, TTNavigationControllerChildProtocol>

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
    self.shouldCancelNetworkTasksWhenDismissed = YES;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    [self loadCustomNavigationBar];
    [self loadSubviews];
    
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
    
    if (!self.parentViewController && self.shouldCancelNetworkTasksWhenDismissed) {
#if __has_include("TTNetworkCancellable.h")
        [self tt_cancelNetworkTasks];
#endif
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

- (void)setupDefaultLeftCloseBarItem {
    [self tt_addLeftBarItemWithTitle:@"取消" image:nil selector:@selector(tt_goback)];
}

- (void)setupDefaultRightCloseBarItem {
    [self tt_addRightBarItemWithTitle:@"取消" image:nil selector:@selector(tt_goback)];
}

- (UIView *)addPulldownToGobackHeaderInScrollView:(UIScrollView *)scrollView {
    if (!scrollView) { return nil; }
    TTPulldownDismissHeader *header = [TTPulldownDismissHeader headerInScrollView:scrollView target:self selector:@selector(tt_goback)];
    return header;
}

- (BOOL)navigationControllerShouldPopViewController {
    [self goback];
    return NO;
}
- (void)goback {
    [self tt_goback];
}

@end
    
