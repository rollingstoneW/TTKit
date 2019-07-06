//
//  UHNewFeatureGuideView.m
//  GuideView
//
//  Created by 韦振宁 on 16/7/1.
//  Copyright © 2016年 wzhnRabbit. All rights reserved.
//

#import "UHNewFeatureGuideView.h"
#import "UHNewFeaturesGuideManager.h"
#import "TTKit.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"

static const CGFloat kCircleWidthHeightRaito = 93.f / 54.f;
static const CGFloat kNFMarginLeft = 18.f;

@interface UHNewFeatureGuideView ()

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, strong) UIButton *buttonShowing;
@property (nonatomic, strong) UIImageView *circleImageShowing;
@property (nonatomic, strong) UILabel *labelShowing;
@property (nonatomic, strong) UIImageView *arrowShowing;

@property (nonatomic, assign) BOOL isTouchingButton;

@end

@implementation UHNewFeatureGuideView
@synthesize features = _features;

+ (instancetype) showViewAddedToView:(UIView *)view withNewFeatures:(NSMutableArray<UHNewFeature *> *)features {
    UHNewFeatureGuideView *guideView = [[UHNewFeatureGuideView alloc] initWithFrame:view.bounds];
    guideView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:guideView];
    
    guideView.features = features;
    return guideView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    [self.layer addSublayer:self.maskLayer];
    [self tt_addTapGestureWithTarget:self selector:@selector(buttonClick:)];
}

- (void)setFeatures:(NSArray<UHNewFeature *> *)features {
    _features = features;
    self.index = 0;

    [self addLabelAndButton];
}

- (void) addLabelAndButton {
    [self addEmptyButtonWithFeature:self.features[self.index] tag:self.index];
    self.labelShowing = [self addLabelWithFeature:self.features[self.index]];
}

- (void) fire {
    [self buttonClick:self.buttonShowing];
}

- (void) buttonClick:(UIButton *)button {
    UHNewFeature *feature = self.features[self.index];
    if ([button isKindOfClass:[UIButton class]]) {
        [button removeFromSuperview];
    } else {
        feature.shouldFire = NO;
        [self.buttonShowing removeFromSuperview];
    }
    
    [[UHNewFeaturesGuideManager sharedGuideManager] fireFeature:feature];
    
    self.index ++;
    
    [self.labelShowing removeFromSuperview];
    [self.arrowShowing removeFromSuperview];
    [self.buttonShowing removeFromSuperview];
    [self.circleImageShowing removeFromSuperview];
    self.labelShowing = nil;
    self.arrowShowing = nil;
    self.buttonShowing = nil;
    self.circleImageShowing = nil;
    
    [self.maskLayer removeFromSuperlayer];
    self.maskLayer = nil;
    [self.layer addSublayer:self.maskLayer];

    if (self.index == self.features.count) {
        [self removeFromSuperview];
        if (self.disappearBlock) {
            self.disappearBlock();
        }
    } else {
        [self addLabelAndButton];
    }
}

- (void) addEmptyButtonWithFeature:(UHNewFeature *)feature tag:(NSInteger)tag {
    
    CGRect frame = feature.targetFrame;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.buttonShowing = button;
    
    if (feature.guideMode == UHNewFeatureGuideModeCircle) {
        UIImageView *circleImageView = [[UIImageView alloc] initWithImage:[self imageNamed:@"icon_newfunction_circle"]];
        [self addSubview:circleImageView];
        self.circleImageShowing = circleImageView;
        
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        if (width / height > kCircleWidthHeightRaito) {
            height = width / kCircleWidthHeightRaito;
        } else {
            width = height * kCircleWidthHeightRaito;
        }
        
        CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        frame.size.width = width + 10;
        frame.size.height = height + 10;
        button.center = center;
        
        circleImageView.frame = frame;
        circleImageView.center = center;
    } else {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithCGPath:self.maskLayer.path];
        [maskPath appendPath:[UIBezierPath bezierPathWithRect:frame]];
        self.maskLayer.fillRule = kCAFillRuleEvenOdd;
        self.maskLayer.path = maskPath.CGPath;
    }
}

- (UILabel *) addLabelWithFeature:(UHNewFeature *)feature {
    
    BOOL isDirectionTop = CGRectGetMinY(feature.targetFrame) < CGRectGetHeight(self.frame) * 0.6f;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.clipsToBounds = YES;
    containerView.layer.cornerRadius = 8;
    [self addSubview:containerView];
    
    UIImageView *tipImageView = [[UIImageView alloc] init];
    [tipImageView setImage:[self imageNamed:@"icon_tip"]];
    [containerView addSubview:tipImageView];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.preferredMaxLayoutWidth = 180.f;
    label.font = kTTFont_12;
    label.textColor = kTTColor_66;
    label.text = feature.desc;
    [label sizeToFit];
    [containerView addSubview:label];
    
    
    CGFloat containerTop = 276;
    CGFloat targetMaxY = feature.targetFrame.origin.y + feature.targetFrame.size.height;
    
    if (CGRectGetMinY(feature.targetFrame) <= containerTop) {
        if (targetMaxY > containerTop) {
            containerTop = targetMaxY + 20.f;
        }
    }
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(containerTop);
        make.width.equalTo(@210);
        make.centerX.equalTo(self);
        make.height.greaterThanOrEqualTo(@115);//最少是150
    }];
    
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(20);
        make.centerX.equalTo(containerView);
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipImageView.mas_bottom).offset(15);
        make.width.equalTo(@180);
        make.centerX.equalTo(containerView);
        make.bottom.equalTo(containerView).offset(-20);
    }];
    
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - kNFMarginLeft * 2, 0)];
//    label.numberOfLines = 0;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - kNFMarginLeft * 2;
//    label.font = [UIFont boldSystemFontOfSize:20.f];
//    label.textColor = [UIColor whiteColor];
//    label.text = feature.desc;
//    [label sizeToFit];
//    [self addSubview:label];
    self.labelShowing = label;
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39.f, 48.f)];
//    [self addSubview:arrow];
    self.arrowShowing = arrow;
    
    CGFloat centerY;
    if (isDirectionTop) {
        centerY = CGRectGetMaxY(feature.targetFrame) + CGRectGetHeight(label.frame) / 2 + 5.f;
    } else {
        centerY = CGRectGetMinY(feature.targetFrame) - CGRectGetHeight(label.frame) / 2 - 5.f;
    }
    label.center = CGPointMake(CGRectGetMidX(feature.targetFrame), centerY);
    
    BOOL isDirectionLeft = CGRectGetMidX(feature.targetFrame) < CGRectGetMidX(self.frame);
    
    CGRect arrowFrame;
    CGRect labelFrame = label.frame;
    
    UIView *highlightedView = self.circleImageShowing ? self.circleImageShowing : self.buttonShowing;
    
    if (isDirectionTop) {
        if (isDirectionLeft) {
            arrow.image = [self imageNamed:@"icon_newfunction_arrow_topleft"];
            arrowFrame = CGRectMake(highlightedView.right + arrow.width, highlightedView.bottom, arrow.width, arrow.height);
            labelFrame.origin.x = CGRectGetMaxX(arrowFrame) - CGRectGetWidth(labelFrame) / 2;
        } else {
            arrow.image = [self imageNamed:@"icon_newfunction_arrow_topright"];
            arrowFrame = CGRectMake(highlightedView.left - arrow.width, highlightedView.bottom, arrow.width, arrow.height);
            labelFrame.origin.x = CGRectGetMinX(arrowFrame) - CGRectGetWidth(labelFrame) / 2;
        }
        labelFrame.origin.y = CGRectGetMaxY(arrowFrame) + 5.f;
    } else {
        if (isDirectionLeft) {
            arrow.image = [self imageNamed:@"icon_newfunction_arrow_bottomleft"];
            arrowFrame = CGRectMake(highlightedView.right + arrow.width, highlightedView.top - arrow.height, arrow.width, arrow.height);
            labelFrame.origin.x = CGRectGetMaxX(arrowFrame) - CGRectGetWidth(labelFrame) / 2;
        } else {
            arrow.image = [self imageNamed:@"icon_newfunction_arrow_bottomright"];
            arrowFrame = CGRectMake(highlightedView.left - arrow.width, highlightedView.top - arrow.height, arrow.width, arrow.height);
            labelFrame.origin.x = CGRectGetMinX(arrowFrame) - CGRectGetWidth(labelFrame) / 2;
        }
        labelFrame.origin.y = CGRectGetMinY(arrowFrame) - 5.f - labelFrame.size.height;
    }
    if (arrowFrame.origin.x < kNFMarginLeft) {
        arrowFrame.origin.x = kNFMarginLeft;
    } else if (CGRectGetMaxX(arrowFrame) > CGRectGetWidth(self.bounds) - kNFMarginLeft) {
        arrowFrame.origin.x = CGRectGetWidth(self.bounds) - kNFMarginLeft - CGRectGetWidth(arrowFrame);
    }
    arrow.frame = arrowFrame;
    label.frame = labelFrame;
    
    if (CGRectGetMinX(label.frame) < kNFMarginLeft || CGRectGetMaxX(label.frame) > CGRectGetWidth(self.frame) - kNFMarginLeft) {
        CGRect frame = label.frame;
        
        if (CGRectGetMidX(arrowFrame) > CGRectGetMidX(self.frame)) {
            frame.origin.x = CGRectGetWidth(self.frame) - kNFMarginLeft - frame.size.width;
        } else {
            frame.origin.x = kNFMarginLeft;
        }
        
        label.frame = frame;
    }
    return label;
}

- (CAShapeLayer *) maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        [path closePath];
        _maskLayer.path = path.CGPath;
        _maskLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor;
    }
    return _maskLayer;
}

- (UIImage *)imageNamed:(NSString *)imageName {
    return [UIImage tt_imageNamed:imageName bundle:[NSBundle tt_bundleWithName:@"TTKit"]];
}

@end
