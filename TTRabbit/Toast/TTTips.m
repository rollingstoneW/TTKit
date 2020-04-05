//
//  TTTips.m
//  TTRabbit
//
//  Created by 郭冰洁 on 2020/4/5.
//

#import "TTTips.h"
#import <Masonry/Masonry.h>
#import "TTCategories.h"
#import "NSBundle+TTToast.h"

@interface TTTipsView : UIView

@property (nonatomic, strong) dispatch_block_t tapedBlock;

@end

@implementation TTTipsView

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
        make.size.equalTo(view);
    }];
}

- (instancetype)initWithImage:(UIImage *)image tips:(id)tips block:(dispatch_block_t)block {
    if (self = [super init]) {
        self.tapedBlock = block;
        UIView *contentView = [self contentViewWithImage:image tips:tips];
        [self addContentView:contentView];
        [self setup];
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView block:(dispatch_block_t)block {
    if (self = [super init]) {
        self.tapedBlock = block;
        [self addContentView:customView];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    if (self.tapedBlock) {
        [self tt_addTapGestureWithTarget:self selector:@selector(dismiss)];
    }
}

- (void)addContentView:(UIView *)contentView {
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.lessThanOrEqualTo(self);
    }];
}

- (UIView *)contentViewWithImage:(UIImage *)image tips:(id)tips {
    UIView *contentView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(contentView);
        make.width.lessThanOrEqualTo(contentView).multipliedBy(0.8);
    }];

    UILabel *label = [UILabel labelWithFont:kTTFont_16 textColor:kTTColor_33];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.bottom.centerX.equalTo(contentView);
        make.width.lessThanOrEqualTo(contentView).multipliedBy(0.8);
    }];

    if ([tips isKindOfClass:[NSString class]]) {
        label.text = tips;
    } else if ([tips isKindOfClass:[NSAttributedString class]]) {
//        [tips setLineSpacing:5];
        label.attributedText = tips;
//        label.textAlignment = NSTextAlignmentCenter;
    }

    return contentView;
}

- (void)dismiss {
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        !self.tapedBlock ?: self.tapedBlock();
    }];
}

@end


@implementation UIView (TTTips)

- (__kindof UIView *)tt_showEmptyTipViewWithTapedBlock:(dispatch_block_t)block {
    return [self tt_showTipViewWithTitle:@"暂无数据"
                                   image:[UIImage tt_imageNamed:@"tt_empty_placeholder" bundle:[NSBundle tt_toastBundle]]
                              tapedBlock:block];
}
- (__kindof UIView *)tt_showNetErrorTipViewWithTapedBlock:(dispatch_block_t)block {
    NSString *tip = @"暂无数据\n点击重试";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tip];
    [attr addAttributes:@{NSFontAttributeName:kTTFont_14} range:[tip rangeOfString:@"点击重试"]];
    return [self tt_showTipViewWithTitle:attr
                                   image:[UIImage tt_imageNamed:@"tt_empty_placeholder" bundle:[NSBundle tt_toastBundle]]
                              tapedBlock:block];
}
- (__kindof UIView *)tt_showTipViewWithTitle:(id)title image:(UIImage *)image tapedBlock:(dispatch_block_t)block {
    TTTipsView *tipsView = [[TTTipsView alloc] initWithImage:image tips:title block:block];
    [tipsView showInView:self];
    return tipsView;
}
- (UIView *)tt_showTipViewWithCustomView:(UIView *)customView tapedBlock:(dispatch_block_t)block {
    TTTipsView *tipsView = [[TTTipsView alloc] initWithCustomView:customView block:block];
    [tipsView showInView:self];
    return tipsView;
}

@end

@implementation UIViewController (TTTips)

- (__kindof UIView *)tt_showEmptyTipViewWithTapedBlock:(dispatch_block_t)block {
    return [self.view tt_showEmptyTipViewWithTapedBlock:block];
}
- (__kindof UIView *)tt_showNetErrorTipViewWithTapedBlock:(dispatch_block_t)block {
    return [self.view tt_showNetErrorTipViewWithTapedBlock:block];
}
- (__kindof UIView *)tt_showTipViewWithTitle:(id)title image:(UIImage *)image tapedBlock:(dispatch_block_t)block {
    return [self.view tt_showTipViewWithTitle:title image:image tapedBlock:block];
}

- (UIView *)tt_showTipViewWithCustomView:(UIView *)customView tapedBlock:(dispatch_block_t)block {
    return [self.view tt_showTipViewWithCustomView:customView tapedBlock:block];
}


@end
