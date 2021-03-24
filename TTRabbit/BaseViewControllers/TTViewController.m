//
//  TTViewController.m
//  TTKit
//
//  Created by rollingstoneW on 2019/5/21.
//  Copyright © 2019 TTKit. All rights reserved.
//

NSNotificationName TTViewControllerViewDidLoadNotification = @"TTViewControllerViewDidLoadNotification";
NSNotificationName TTViewControllerViewWillAppearNotification = @"TTViewControllerViewWillAppearNotification";
NSNotificationName TTViewControllerViewDidAppearNotification = @"TTViewControllerViewDidAppearNotification";
NSNotificationName TTViewControllerViewWillDisappearNotification = @"TTViewControllerViewWillDisappearNotification";
NSNotificationName TTViewControllerViewDidDisappearNotification = @"TTViewControllerViewDidDisappearNotification";
NSNotificationName TTViewControllerViewDeallocedNotification = @"TTViewControllerViewDeallocedNotification";

#import "TTViewController.h"
#import "TTViewController+LifeCycle.h"
#import "TTUIKitFactory.h"
#import "UIView+TTUtil.h"
#import "TTPulldownDismissHeader.h"
#import "TTNavigationControllerChildProtocol.h"

#if __has_include("TTNetworkCancellable.h")
#import "TTNetworkCancellable.h"
#endif

NSString *const TTViewControllerDidDismissNotification = @"TTViewControllerDidDismissNotification";
static BOOL _postLifeCycleNotifications = NO;

@interface TTViewController () <UIGestureRecognizerDelegate, TTNavigationControllerChildProtocol>

@property (nonatomic, strong) NSMutableArray *lifeCycleBlocks;

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
    self.lifeCycleState = TTViewControllerLifeCycleStateInited;
}

#define PostNotification(notification) if (TTViewController.postLifeCycleNotifications) { \
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self userInfo:nil]; \
}

- (void)viewDidLoad {
    self.lifeCycleState = TTViewControllerLifeCycleStateBeforeDidLoad;
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self loadCustomNavigationBar];
    [self loadSubviews];
    
    self.lifeCycleState = TTViewControllerLifeCycleStateDidLoad;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_orientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    PostNotification(TTViewControllerViewDidLoadNotification);
}

- (void)viewWillAppear:(BOOL)animated {
    self.lifeCycleState = TTViewControllerLifeCycleStateBeforeWillAppear;
    [super viewWillAppear:animated];

    self.navigationItem.hidesBackButton = self.hidesBackButton;
    [self.navigationController setNavigationBarHidden:self.tt_prefersNavigationBarHidden animated:animated];
    
    self.lifeCycleState = TTViewControllerLifeCycleStateWillAppear;
    PostNotification(TTViewControllerViewWillAppearNotification);
}

- (void)viewDidAppear:(BOOL)animated {
    self.lifeCycleState = TTViewControllerLifeCycleStateBeforeDidAppear;
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.hasAppeared = YES;
    });
    self.isWholeAppeared = YES;

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = !self.disablesSwipeBackGesture && self.navigationController.viewControllers.count > 1;
    
    self.lifeCycleState = TTViewControllerLifeCycleStateDidAppear;
    PostNotification(TTViewControllerViewDidAppearNotification);
}

- (void)viewWillDisappear:(BOOL)animated {
    self.lifeCycleState = TTViewControllerLifeCycleStateBeforeWillDisappear;
    [super viewWillDisappear:animated];
    self.isWholeAppeared = NO;
    
    self.lifeCycleState = TTViewControllerLifeCycleStateWillDisappear;
    PostNotification(TTViewControllerViewWillDisappearNotification);
}

- (void)viewDidDisappear:(BOOL)animated {
    self.lifeCycleState = TTViewControllerLifeCycleStateBeforeDidDisappear;
    [super viewDidDisappear:animated];
    
    if (!self.parentViewController && self.shouldCancelNetworkTasksWhenDismissed) {
#if __has_include("TTNetworkCancellable.h")
        [self tt_cancelNetworkTasks];
#endif
    }
    
    self.lifeCycleState = TTViewControllerLifeCycleStateDidDisappear;
    PostNotification(TTViewControllerViewDidDisappearNotification);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.customNavigationBar) {
        [self.view bringSubviewToFront:self.customNavigationBar];
    }
}

- (void)dealloc {
#if DEBUG
    NSLog(@"\n----------------\ndealloced: %@ title = %@\n----------------", self, self.title);
#endif
    self.lifeCycleState = TTViewControllerLifeCycleStateDealloced;
    PostNotification(TTViewControllerViewDeallocedNotification);
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
    if (!self.navigationController.navigationBar.isHidden && !self.navigationController.navigationBar.isTranslucent) {
        return UIEdgeInsetsZero;
    }
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

#define registLifeCycleBlock(targetStates, block) \
if (!block) { return; } \
if ([targetStates containsObject:@(self.lifeCycleState)]) { \
    block(); \
    if (!invokesAlways) { \
        return; \
    } \
} \
[self.lifeCycleBlocks addObject:@{@"always": @(invokesAlways), @"block": block, @"state": targetStates.firstObject}];

- (void)excuteWhenWillAppear:(dispatch_block_t)willAppear invokesAlways:(BOOL)invokesAlways {
    NSArray *targetStates = @[@(TTViewControllerLifeCycleStateWillAppear),
                              @(TTViewControllerLifeCycleStateBeforeDidAppear),
                              @(TTViewControllerLifeCycleStateDidAppear)];
    registLifeCycleBlock(targetStates, willAppear);
}

- (void)excuteWhenDidAppear:(dispatch_block_t)didAppear invokesAlways:(BOOL)invokesAlways {
    registLifeCycleBlock(@[@(TTViewControllerLifeCycleStateDidAppear)], didAppear);
}

- (void)excuteWhenWillDisappear:(dispatch_block_t)willDisappear invokesAlways:(BOOL)invokesAlways {
    NSArray *targetStates = @[@(TTViewControllerLifeCycleStateWillDisappear),
                              @(TTViewControllerLifeCycleStateBeforeDidDisappear),
                              @(TTViewControllerLifeCycleStateDidDisappear)];
    registLifeCycleBlock(targetStates, willDisappear);
}

- (void)excuteWhenDidDisappear:(dispatch_block_t)didDisappear invokesAlways:(BOOL)invokesAlways {
    registLifeCycleBlock(@[@(TTViewControllerLifeCycleStateDidDisappear)], didDisappear);
}
#undef registLifeCycleBlock

- (void)setLifeCycleState:(TTViewControllerLifeCycleState)lifeCycleState {
    _lifeCycleState = lifeCycleState;
    [_lifeCycleBlocks enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dict[@"state"] integerValue] == lifeCycleState) {
            ((dispatch_block_t)dict[@"block"])();
            if (![dict[@"always"] boolValue]) {
                [_lifeCycleBlocks removeObjectAtIndex:idx];
            }
        }
        *stop = YES;
    }];
}

- (NSMutableArray *)lifeCycleBlocks {
    if (!_lifeCycleBlocks) {
        _lifeCycleBlocks = [NSMutableArray array];
    }
    return _lifeCycleBlocks;
}

+ (BOOL)postLifeCycleNotifications {
    return _postLifeCycleNotifications;
}

+ (void)setPostLifeCycleNotifications:(BOOL)postLifeCycleNotifications {
    _postLifeCycleNotifications = postLifeCycleNotifications;
}

#pragma mark UIGestureRecognizerDelegate

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
//        UINavigationController *navi = self.navigationController;
//        if (!navi) {
//            navi = gestureRecognizer.view.viewController;
//        }
//        if (navi.topViewController != self) {
//            NSLog(@"self: %@, top: %@, vcs: %@", self, navi.topViewController, navi.viewControllers);
//        }
//        return self.navigationController.viewControllers.count > 1;
//    }
//    return YES;
//}

@end
    
