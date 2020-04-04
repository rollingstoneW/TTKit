//
//  TTPulldownDismissHeader.m
//  TTKit
//
//  Created by 滚石 on 2019/7/6.
//

#import "TTPulldownDismissHeader.h"
#import "TTKit.h"
#import "UIView+YYAdd.h"

@interface TTPulldownDismissHeader ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic,   weak) UIScrollView *scrollView;
@property (nonatomic,   weak) id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation TTPulldownDismissHeader

+ (instancetype)headerInScrollView:(UIScrollView *)scrollView target:(id)target selector:(SEL)selector {
    return [[TTPulldownDismissHeader alloc] initWithScrollView:scrollView target:target selector:selector];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView target:(id)target selector:(SEL)selector {
    if (!scrollView || !target || ![target respondsToSelector:selector]) { return nil; }
    if (self = [super init]) {
        _scrollView = scrollView;
        _target = target;
        _selector = selector;
        [self setup];
    }
    return self;
}

- (void)setup {
    static const CGFloat headerHeight = 44;
    self.frame = CGRectMake(0, -self.scrollView.contentInset.top - headerHeight, self.scrollView.frame.size.width, headerHeight);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:self];

    self.label = [UILabel labelWithText:@"下拉关闭页面" font:kTTFont_16 textColor:kTTColor_66];
    [self.label sizeToFit];
    [self addSubview:self.label];

    __weak __typeof(self) weakSelf = self;
    [self tt_observeObject:self.scrollView forKeyPath:@"contentOffset" context:nil changed:^(NSString *keyPath, id newData, id oldData, void * context) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleContentOffset:[newData CGPointValue]];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.top = -self.scrollView.contentInset.top - self.height;
    self.width = self.scrollView.width;
    self.label.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)handleContentOffset:(CGPoint)contentOffset {
    if (CGRectIsEmpty(self.scrollView.bounds)) {
        return;
    }
    CGFloat visibleOffsetY = contentOffset.y + self.scrollView.tt_safeAreaInsets.top;
    if (visibleOffsetY <= self.frame.origin.y - 20) {
        if ([self.target respondsToSelector:self.selector]) {
            TTSuppressPerformSelectorLeakWarning([self.target performSelector:self.selector];)
        }
    }
}

@end
